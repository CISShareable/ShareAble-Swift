import SwiftUI
import FirebaseAuth

/// Send a Firebase Auth
struct ChangePasswordView: View {
    @EnvironmentObject var authService: AuthService

    /// Pass true when presented from Settings (logged-in context, matches
    /// changePassword.js). Pass false when presented from the login screen
    /// (matches changePassword_login.js, which has no session to check against).
    var requireMatchWithCurrentUser: Bool = true

    @State private var email = ""
    @State private var statusMessage: String?
    @State private var isError = false
    @State private var isSending = false

    var body: some View {
        Form {
            Section {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            } footer: {
                Text("We'll send a password reset link to this email.")
            }

            if let statusMessage {
                Text(statusMessage)
                    .foregroundStyle(isError ? .red : .green)
            }

            Section {
                Button {
                    Task { await sendResetEmail() }
                } label: {
                    if isSending {
                        ProgressView()
                    } else {
                        Text("Send reset email")
                    }
                }
                .disabled(email.isEmpty || isSending)
            }
        }
        .navigationTitle("Change password")
        .onAppear {
            
            if requireMatchWithCurrentUser, email.isEmpty {
                email = authService.currentUserProfile?.email ?? authService.currentUser?.email ?? ""
            }
        }
    }

    private func sendResetEmail() async {
        statusMessage = nil
        isError = false

        if requireMatchWithCurrentUser,
           let currentEmail = authService.currentUser?.email,
           currentEmail != email {
            statusMessage = "Incorrect email!"
            isError = true
            return
        }

        isSending = true
        defer { isSending = false }
        do {
            try await authService.sendPasswordReset(email: email)
            statusMessage = "Password reset email sent!"
        } catch {
            statusMessage = "Failed to send password reset email: \(error.localizedDescription)"
            isError = true
        }
    }
}
