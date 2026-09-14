import SwiftUI

/// Replaces search.html + search.js: free-text search bar plus category tiles.
/// Submitting either one loads SearchResultsView, same as navigating to
/// result.html?search=... or result.html?category=... in the JS version.
struct SearchView: View {
    @State private var searchText = ""
    @State private var submittedQuery: SearchQuery?
    @State private var selectedUser: AppUser?
    @State private var selectedItem: DonationItem?

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Search items", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onSubmit {
                        guard !searchText.isEmpty else { return }
                        submittedQuery = .text(searchText)
                    }
                
                // "Users" is a search mode, not an item category — pulled out
                                // of the grid and given the full width so it visually reads
                                // as a different kind of option, not just another category.
                                Button {
                                    submittedQuery = .category("Users")
                                } label: {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                        Text("Browse People")
                                            .font(.subheadline.bold())
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption.bold())
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.brandGreen.opacity(0.15))
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.horizontal)

                Text("Browse by category")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(ItemCategory.all) { category in
                            Button {
                                submittedQuery = .category(category.id)
                            } label: {
                                Text(category.displayName)
                                    .font(.subheadline.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 24)
                                    .background(Color.brandGreenLight.opacity(0.15))
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }

                        
                    }
                    .padding(.horizontal)
                }

                Text("Filter by year level")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(1...13, id: \.self) { year in
                            Button {
                                submittedQuery = .yearLevel(year)
                            } label: {
                                Text("Year \(year)")
                                    .font(.subheadline.bold())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.brandGreen.opacity(0.15))
                                    .foregroundStyle(.primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Search")
            .navigationDestination(item: $submittedQuery) { query in
                SearchResultsView(query: query, selectedUser: $selectedUser, selectedItem: $selectedItem)
            }

            .navigationDestination(item: $selectedItem) { item in
                ProductInfoView(item: item)
            }

            .navigationDestination(item: $selectedUser) { user in
                AnotherProfileView(userId: user.id ?? user.userId)
            }
        }
    }
}

/// Mirrors the two query-param branches (`search=`, `category=`) in result.js,
/// plus a new `.yearLevel` branch (not present in the original app) for
/// filtering by suggested year level.
enum SearchQuery: Hashable, Identifiable {
    case text(String)
    case category(String)
    case yearLevel(Int)

    var id: String {
        switch self {
        case .text(let value): return "text:\(value)"
        case .category(let value): return "category:\(value)"
        case .yearLevel(let value): return "yearLevel:\(value)"
        }
    }
}

/// Replaces result.html + result.js
struct SearchResultsView: View {
    let query: SearchQuery
    @Binding var selectedUser: AppUser?
    @Binding var selectedItem: DonationItem?

    @State private var items: [DonationItem] = []
    @State private var users: [AppUser] = []
    @State private var isLoading = true

    private var isUserSearch: Bool {
        if case .category("Users") = query { return true }
        return false
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if isUserSearch {
                if users.isEmpty {
                    ContentUnavailableView("No users found", systemImage: "person.slash")
                } else {
                    List(users) { user in
                        Button {
                            selectedUser = user
                        } label: {
                            HStack {
                                UserRow(user: user)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption.bold())
                                    .foregroundStyle(.tertiary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            } else if items.isEmpty {
                ContentUnavailableView("No results", systemImage: "magnifyingglass")
            } else {
                List(items) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        HStack {
                            ItemRow(item: item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundStyle(.tertiary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private var title: String {
        switch query {
        case .text(let value): return "\"\(value)\""
        case .category("Users"): return "People"
        case .category(let value): return ItemCategory.displayName(for: value)
        case .yearLevel(let year): return "Year \(year)"
        }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            switch query {
            case .text(let value):
                items = try await ItemService.shared.searchItems(byNameOrCategory: value)
            case .category("Users"):
                users = try await ItemService.shared.fetchAllUsers()
            case .category(let value):
                items = try await ItemService.shared.fetchItems(inCategory: value)
            case .yearLevel(let year):
                items = try await ItemService.shared.fetchItems(forYearLevel: year)
            }
        } catch {
            print("Error loading search results: \(error)")
        }
    }
}

/// Reusable row for the "Users" category results, mirrors the profile
/// card markup built dynamically in result.js.
struct UserRow: View {
    let user: AppUser

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: user.profileImageUrl ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(user.username).font(.headline)
                Text(user.email).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// .navigationDestination(item:) requires Hashable (not just Identifiable),
// and AppUser can't auto-synthesize it because of the @DocumentID property
// wrapper — this manual conformance, based on id, is what makes the
// selectedUser-driven navigation above possible.
extension AppUser: Hashable {
    static func == (lhs: AppUser, rhs: AppUser) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

