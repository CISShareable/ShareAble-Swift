import SwiftUI
import FirebaseAuth

struct RootView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        Group {
            if authService.isLoading {
                ProgressView()
            } else if authService.isSignedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

/// nav icon (home, upload, setting, profile — active/inactive states).
struct MainTabView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            UploadView()
                .tabItem { Label("Upload", systemImage: "plus.square") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        // If the profile document failed to load (bad Firestore data, a
        // permissions issue, etc), surface it here instead of leaving people
        // stuck with "you must be logged in" everywhere with no explanation.
        .overlay(alignment: .top) {
            if let error = authService.profileLoadError, authService.currentUserProfile == nil {
                ProfileLoadErrorBanner(message: error) {
                    if let uid = authService.currentUser?.uid {
                        Task { await authService.fetchProfile(uid: uid) }
                    }
                }
            }
        }
    }
}

struct ProfileLoadErrorBanner: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Couldn't load your profile")
                .font(.subheadline.bold())
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
            Button("Retry", action: onRetry)
                .font(.caption.bold())
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .shadow(radius: 4)
    }
}
