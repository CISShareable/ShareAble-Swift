import SwiftUI
import Combine
import FirebaseAuth

/// Replaces product_info.html + product_info.js.
struct ProductInfoView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel: ProductInfoViewModel

    init(item: DonationItem) {
        _viewModel = StateObject(wrappedValue: ProductInfoViewModel(item: item))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                AsyncImage(url: URL(string: viewModel.item.itemImageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(viewModel.item.name)
                    .font(.headline)

                Text(viewModel.item.quantity)
                    .font(.subheadline)

                if let yearLevelDisplay = viewModel.item.suggestedYearLevelDisplay {
                    Text(yearLevelDisplay)
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.brandGreen.opacity(0.15))
                        .foregroundStyle(Color.brandGreenDark)
                        .clipShape(Capsule())
                }

                Text("Uploaded on \(viewModel.item.time) by \(viewModel.item.username)")
                    .font(.caption)
                    .foregroundStyle(Color.brandGreenLight)

                Divider()

                actionArea
            }
            .padding()
        }
        .navigationTitle("Item")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var actionArea: some View {
        if let currentUserId = authService.currentUser?.uid {
            switch viewModel.item.viewerRole(currentUserId: currentUserId) {
            case .ownerSeesRating(let rating):
                Text("This item is already rated: \(rating, specifier: "%.1f")")
                    .foregroundStyle(.red)

            case .buyerSeesOwnRating(let rating):
                Text("This item is already rated by you: \(rating)")
                    .foregroundStyle(.red)

            case .ownerAwaitingReturn(let reservedByName):
                VStack(spacing: 12) {
                    Text("This item is reserved by \(reservedByName)")
                        .foregroundStyle(.red)
                    Button("Close item") {
                        Task { await viewModel.closeItem() }
                    }
                    .buttonStyle(.borderedProminent)
                }

            case .buyerCanRate:
                RatingPrompt { rating in
                    Task { await viewModel.submitRating(rating) }
                }

            case .buyerCanCancelReserve:
                Button("Cancel reserve") {
                    Task { await viewModel.cancelReservation() }
                }
                .buttonStyle(.bordered)

            case .ownerCanClose:
                Button("Close item") {
                    Task { await viewModel.closeItem() }
                }
                .buttonStyle(.borderedProminent)

            case .closed:
                Text("This item is closed!")
                    .foregroundStyle(.red)

            case .buyerCanReserve:
                Button("Reserve item") {
                    Task {
                        await viewModel.reserve(
                            userId: currentUserId,
                            username: authService.currentUserProfile?.username ?? ""
                        )
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct RatingPrompt: View {
    @State private var rating: Double = 3
    let onSubmit: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rate your experience")
                .font(.subheadline.bold())
            Slider(value: $rating, in: 1...5, step: 1)
            Button("Submit") {
                onSubmit(Int(rating))
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

@MainActor
final class ProductInfoViewModel: ObservableObject {
    @Published var item: DonationItem

    init(item: DonationItem) {
        self.item = item
    }

    func reserve(userId: String, username: String) async {
        guard let id = item.id else { return }
        do {
            try await ItemService.shared.reserve(itemId: id, byUserId: userId, reserverName: username)
            item.reserved = userId
            item.reservedName = username
        } catch {
            print("Error reserving item: \(error)")
        }
    }

    func cancelReservation() async {
        guard let id = item.id else { return }
        do {
            try await ItemService.shared.cancelReservation(itemId: id)
            item.reserved = nil
            item.reservedName = nil
        } catch {
            print("Error cancelling reservation: \(error)")
        }
    }

    func closeItem() async {
        guard let id = item.id else { return }
        do {
            try await ItemService.shared.closeItem(itemId: id)
            item.closed = true
        } catch {
            print("Error closing item: \(error)")
        }
    }

    func submitRating(_ rating: Int) async {
        guard let id = item.id else { return }
        do {
            try await ItemService.shared.submitRating(itemId: id, ownerUserId: item.userId, rating: rating)
            item.rating = rating
        } catch {
            print("Error submitting rating: \(error)")
        }
    }
}

