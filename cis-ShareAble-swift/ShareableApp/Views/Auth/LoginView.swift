import SwiftUI

/// Replaces login.html + login.js
struct LoginView: View {
    @EnvironmentObject var authService: AuthService

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSubmitting = false
    @State private var showSignUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Text("Welcome back")
                    .font(.title.bold())

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Button {
                    Task { await login() }
                } label: {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Log in")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.isEmpty || isSubmitting)

                Button("Create an account") {
                    showSignUp = true
                }
                .font(.footnote)

                NavigationLink("Forgot password?") {
                    ChangePasswordView(requireMatchWithCurrentUser: false)
                }
                .font(.footnote)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }

    private func login() async {
        errorMessage = nil
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
