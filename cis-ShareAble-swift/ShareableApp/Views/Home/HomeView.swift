import SwiftUI
import Combine

/// Replaces home.html + home.js
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.items.isEmpty {
                    ContentUnavailableView("No items yet", systemImage: "shippingbox")
                } else {
                    List(viewModel.items) { item in
                        NavigationLink(value: item) {
                            ItemRow(item: item)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Shareable")
            .navigationDestination(for: DonationItem.self) { item in
                ProductInfoView(item: item)
            }
            .task { await viewModel.loadItems() }
            .refreshable { await viewModel.loadItems() }
        }
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var items: [DonationItem] = []
    @Published var isLoading = false

    func loadItems() async {
        isLoading = true
        defer { isLoading = false }
        do {
            items = try await ItemService.shared.fetchAllItems()
        } catch {
            print("Error loading items: \(error)")
        }
    }
}

/// Reusable row, mirrors the item card markup built dynamically in home.js/product_info.js.
struct ItemRow: View {
    let item: DonationItem

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.itemImageUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                Text(item.quantity)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("By \(item.username)")
                    .font(.caption)
                    .foregroundStyle(Color.brandGreenLight)
                if let yearLevelDisplay = item.suggestedYearLevelDisplay {
                    Text(yearLevelDisplay)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.brandGreen.opacity(0.15))
                        .foregroundStyle(Color.brandGreenDark)
                        .clipShape(Capsule())
                }
            }

            Spacer()

            if item.closed {
                Text("Closed")
                    .font(.caption2.bold())
                    .foregroundStyle(.red)
            } else if item.reserved != nil {
                Text("Reserved")
                    .font(.caption2.bold())
                    .foregroundStyle(.orange)
            }
        }
        .padding(.vertical, 4)
    }
}

extension DonationItem: Hashable {
    static func == (lhs: DonationItem, rhs: DonationItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

