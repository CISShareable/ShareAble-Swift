import SwiftUI
import FirebaseAuth

/// Replaces profile.html + profile.js
struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var myItems: [DonationItem] = []
    @State private var activeReservations: [DonationItem] = []
    @State private var completedReservations: [DonationItem] = []

    var body: some View {
        NavigationStack {
            List {
                if let profile = authService.currentUserProfile {
                    Section {
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: profile.profileImageUrl ?? "")) { $0.resizable() } placeholder: {
                                Image(systemName: "person.crop.circle.fill").resizable()
                            }
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())
                            .padding(.top, 8)

                            Text(profile.username)
                                .font(.title3.bold())
                                .foregroundStyle(Color.brandGreenDark)
                            Text(profile.email)
                                .font(.caption)
                                .foregroundStyle(Color.brandGreenDark)
                            if let rating = profile.rating {
                                Text("Rating: \(rating, specifier: "%.1f")")
                                    .font(.caption)
                                    .foregroundStyle(Color.brandGreenDark)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.brandGreen.opacity(0.12))
                    }

                    Section("My items") {
                        if myItems.isEmpty {
                            Text("You haven't uploaded anything yet").foregroundStyle(.secondary)
                        } else {
                            ForEach(myItems) { item in
                                NavigationLink(value: item) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }

                    Section {
                        if activeReservations.isEmpty {
                            Text("Nothing currently reserved").foregroundStyle(.secondary)
                        } else {
                            ForEach(activeReservations) { item in
                                NavigationLink(value: item) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    } header: {
                        Text("Active reservations")
                    } footer: {
                        Text("Items you've reserved that the owner hasn't closed out yet.")
                    }

                    Section {
                        if completedReservations.isEmpty {
                            Text("No completed reservations yet").foregroundStyle(.secondary)
                        } else {
                            ForEach(completedReservations) { item in
                                NavigationLink(value: item) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    } header: {
                        Text("Completed reservations")
                    } footer: {
                        Text("Items you've received. Rate them if you haven't already.")
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationDestination(for: DonationItem.self) { item in
                ProductInfoView(item: item)
            }
            .toolbar {
                NavigationLink("Edit") {
                    EditProfileView()
                }
            }
            .task { await loadAll() }
            .refreshable { await loadAll() }
        }
    }

    private func loadAll() async {
        guard let uid = authService.currentUser?.uid else { return }
        async let items = ItemService.shared.fetchItems(forUserId: uid)
        async let active = ItemService.shared.fetchActiveReservations(forUserId: uid)
        async let completed = ItemService.shared.fetchCompletedReservations(forUserId: uid)

        myItems = (try? await items) ?? []
        activeReservations = (try? await active) ?? []
        completedReservations = (try? await completed) ?? []
    }
}

