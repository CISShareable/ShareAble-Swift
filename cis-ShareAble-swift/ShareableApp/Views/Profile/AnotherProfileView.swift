import SwiftUI

/// Replaces another_profile.html + another_profile.js — a read-only view of
/// someone else's profile, their listings, and their completed reservations.
struct AnotherProfileView: View {
    let userId: String

    @State private var user: AppUser?
    @State private var listings: [DonationItem] = []
    @State private var reservations: [DonationItem] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let user {
                List {
                    Section {
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: user.profileImageUrl ?? "")) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())
                            .padding(.top, 8)

                            Text(user.username)
                                .font(.title3.bold())
                                .foregroundStyle(Color.brandGreenDark)
                            if let rating = user.rating {
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

                    Section("Listings") {
                        if listings.isEmpty {
                            Text("No items listed yet").foregroundStyle(.secondary)
                        } else {
                            ForEach(listings) { item in
                                NavigationLink(value: item) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }

                    Section("Reservations") {
                        if reservations.isEmpty {
                            Text("No completed reservations yet").foregroundStyle(.secondary)
                        } else {
                            ForEach(reservations) { item in
                                NavigationLink(value: item) {
                                    ItemRow(item: item)
                                }
                            }
                        }
                    }
                }
                // Deliberately no .navigationDestination(for: DonationItem.self)
                // here — this view is always reached from SearchResultsView,
                // which already declares that destination for the same
                // NavigationStack. Registering it again here would create the
                // exact "declared earlier on stack, only closest to root
                // used" duplicate warning. If AnotherProfileView ever gets a
                // second entry point outside of Search, move the destination
                // here instead of duplicating it.
            } else {
                ContentUnavailableView("User not found", systemImage: "person.slash")
            }
        }
        .navigationTitle(user?.username ?? "Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let userFetch = ItemService.shared.fetchUser(id: userId)
            async let listingsFetch = ItemService.shared.fetchItems(forUserId: userId)
            async let reservationsFetch = ItemService.shared.fetchCompletedReservations(forUserId: userId)

            user = try await userFetch
            listings = try await listingsFetch
            reservations = try await reservationsFetch
        } catch {
            print("Error loading profile: \(error)")
        }
    }
}

