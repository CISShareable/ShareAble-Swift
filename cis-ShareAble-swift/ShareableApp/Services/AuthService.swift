import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

/// Replaces login.js, signup.js, changePassword.js, changePassword_login.js.
/// Single source of truth for the current auth state; SwiftUI views observe this.
@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var currentUser: FirebaseAuth.User?
    @Published var currentUserProfile: AppUser?
    @Published var isLoading = true
    @Published var profileLoadError: String?

    private var authHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    private init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                if let user {
                    await self?.fetchProfile(uid: user.uid)
                } else {
                    self?.currentUserProfile = nil
                }
                self?.isLoading = false
            }
        }
    }

    deinit {
        if let authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }

    var isSignedIn: Bool { currentUser != nil }

    func fetchProfile(uid: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            currentUserProfile = try snapshot.data(as: AppUser.self)
            profileLoadError = nil
        } catch {
            print("Error fetching user profile: \(error)")
            profileLoadError = error.localizedDescription
        }
    }

    // MARK: - Sign up
    // Mirrors signup.js: validates a CIS-affiliated email, derives yearLevel
    // from the graduation year encoded in the email, writes the user doc.

    enum SignUpError: LocalizedError {
        case invalidEmailDomain
        case invalidEmailFormat

        var errorDescription: String? {
            switch self {
            case .invalidEmailDomain:
                return "Please use a CIS affiliated email to register an account."
            case .invalidEmailFormat:
                return "Invalid email format. Please use a valid CIS email."
            }
        }
    }

    func signUp(username: String, email: String, password: String) async throws {
        guard email.contains("@student.cis.edu.hk") || email.contains("@cis.edu.hk") else {
            throw SignUpError.invalidEmailDomain
        }
        guard let yearLevel = Self.yearLevel(fromEmail: email) else {
            throw SignUpError.invalidEmailFormat
        }

        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = result.user.uid

        let userDoc = AppUser(
            id: uid,
            username: username,
            userId: uid,
            email: email,
            phone: nil,
            yearLevel: yearLevel
        )
        try db.collection("users").document(uid).setData(from: userDoc)
    }

    /// Ported from calcYearLevWithGradYear in signup.js.
    /// NOTE: this assumes the graduation year is embedded in the email
    /// local-part immediately before "@", e.g. "jsmith2027@student.cis.edu.hk".
    private static func yearLevel(fromEmail email: String) -> Int? {
        guard let atIndex = email.firstIndex(of: "@") else { return nil }
        let localPart = email[..<atIndex]
        guard localPart.count >= 4 else { return nil }
        let gradYearString = localPart.suffix(4)
        guard let gradYear = Int(gradYearString) else { return nil }

        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now) - 1 // JS getMonth() is 0-indexed
        let currentYear = calendar.component(.year, from: now)

        if currentMonth >= 7 {
            return 14 - (gradYear - currentYear)
        } else {
            return 13 - (gradYear - currentYear)
        }
    }

    // MARK: - Sign in / out

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    // MARK: - Edit profile
    // Mirrors editProfile.js's `edit()` function.

    func updateProfile(username: String, email: String, phone: String) async throws {
        guard let uid = currentUser?.uid else { return }
        try await db.collection("users").document(uid).updateData([
            "username": username,
            "email": email,
            "phone": phone,
        ])
        await fetchProfile(uid: uid)
    }

    func updateProfileImageURL(_ url: URL) async throws {
        guard let uid = currentUser?.uid else { return }
        try await db.collection("users").document(uid).updateData([
            "profileImageUrl": url.absoluteString
        ])
        await fetchProfile(uid: uid)
    }
}
