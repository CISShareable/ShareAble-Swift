import SwiftUI
import Combine

/// Replaces editProfile.html + editProfile.js
struct EditProfileView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditProfileViewModel()

    var body: some View {
        Form {
            Section("Photo") {
                HStack {
                    Spacer()
                    PhotoSourceButton(selectedImage: $viewModel.selectedImage) {
                        ZStack(alignment: .bottomTrailing) {
                            profileImage
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())

                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white, Color.accentColor)
                        }
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            Section("Your info") {
                TextField("Username", text: $viewModel.username)
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                TextField("Phone", text: $viewModel.phone)
                    .keyboardType(.phonePad)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }

            Section {
                Button {
                    Task {
                        await viewModel.save()
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                } label: {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("Save changes")
                    }
                }
                .disabled(viewModel.username.isEmpty || viewModel.isSaving)
            }
        }
        .navigationTitle("Edit profile")
        .onAppear {
            viewModel.load(from: authService.currentUserProfile)
        }
    }

    @ViewBuilder
    private var profileImage: some View {
        if let image = viewModel.selectedImage {
            Image(uiImage: image).resizable().aspectRatio(contentMode: .fill)
        } else if let urlString = authService.currentUserProfile?.profileImageUrl,
                  let url = URL(string: urlString) {
            AsyncImage(url: url) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: {
                Image(systemName: "person.crop.circle.fill").resizable()
            }
        } else {
            Image(systemName: "person.crop.circle.fill").resizable()
        }
    }
}

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var phone = ""

    @Published var selectedImage: UIImage?

    @Published var isSaving = false
    @Published var errorMessage: String?

    private var didLoadInitialValues = false

    /// Mirrors editProfile.js's initial getDoc() call that populates the form fields.
    func load(from profile: AppUser?) {
        guard !didLoadInitialValues, let profile else { return }
        username = profile.username
        email = profile.email
        phone = profile.phone ?? ""
        didLoadInitialValues = true
    }

    /// Mirrors editProfile.js's `edit()` function: updates the text fields,
    /// then — if a new photo was picked — uploads it and updates profileImageUrl.
    func save() async {
        errorMessage = nil
        isSaving = true
        defer { isSaving = false }

        do {
            try await AuthService.shared.updateProfile(username: username, email: email, phone: phone)

            if let selectedImage {
                let url = try await StorageService.shared.uploadProfileImage(selectedImage)
                try await AuthService.shared.updateProfileImageURL(url)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

