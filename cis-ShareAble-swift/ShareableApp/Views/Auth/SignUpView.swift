import SwiftUI

/// Replaces signup.html + signup.js
struct SignUpView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSubmitting = false

    var body: some View {
        Form {
            Section("Your info") {
                TextField("Username", text: $username)
                TextField("CIS email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                SecureField("Password (min 6 characters)", text: $password)
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Section {
                NavigationLink("Terms & Conditions") {
                    TermsConditionsView()
                }
                .font(.footnote)
            }

            Section {
                Button {
                    Task { await signUp() }
                } label: {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Sign up")
                    }
                }
                .disabled(username.isEmpty || email.isEmpty || password.count < 6 || isSubmitting)
            }
        }
        .navigationTitle("Create account")
    }

    private func signUp() async {
        errorMessage = nil
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await authService.signUp(username: username, email: email, password: password)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
