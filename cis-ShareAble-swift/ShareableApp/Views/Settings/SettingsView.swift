import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Change password") {
                    ChangePasswordView(requireMatchWithCurrentUser: true)
                }
                NavigationLink("About us") {
                    AboutUsView()
                }
                NavigationLink("Privacy policy") {
                    PrivacyPolicyView()
                }
                NavigationLink("Terms & Conditions") {
                    TermsConditionsView()
                }
                Button("Log out", role: .destructive) {
                    try? authService.signOut()
                }
            }
            .navigationTitle("Settings")
        }
    }
}
