import Foundation
import Combine
import FirebaseFirestore

/// Firestore query/update logic
@MainActor
final class ItemService: ObservableObject {
    static let shared = ItemService()
    private let db = Firestore.firestore()
    private init() {}

    // MARK: - Read

    /// home.js: loads the feed of items.
    func fetchAllItems() async throws -> [DonationItem] {
        let snapshot = try await db.collection("items").getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: DonationItem.self) }
    }

    /// product_info.js: single item by ID.
    func fetchItem(id: String) async throws -> DonationItem? {
        let doc = try await db.collection("items").document(id).getDocument()
        return try doc.data(as: DonationItem.self)
    }

    /// another_profile.js / profile.js: items belonging to a given user.
    func fetchItems(forUserId userId: String) async throws -> [DonationItem] {
        let snapshot = try await db.collection("items")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: DonationItem.self) }
    }

    /// result.js: filters open (non-closed) items by name OR category matching
    /// a free-text query. Mirrors the `searchValue` branch in result.js exactly
    /// (case-insensitive substring match against name and category).
    func searchItems(byNameOrCategory query: String) async throws -> [DonationItem] {
        let all = try await fetchAllItems()
        let lowered = query.lowercased()
        return all.filter { item in
            !item.closed &&
            (item.name.lowercased().contains(lowered) ||
             item.category.lowercased().contains(lowered))
        }
    }

    /// result.js: filters open items by an exact category tap (Books, Clothing, etc).
    /// Mirrors the `filterValue` branch in result.js.
    func fetchItems(inCategory category: String) async throws -> [DonationItem] {
        let all = try await fetchAllItems()
        let lowered = category.lowercased()
        return all.filter { !$0.closed && $0.category.lowercased().contains(lowered) }
    }

    /// another_profile.js "reservations" section: items this user reserved
    /// and that have since been closed out (i.e. completed donations received).
    func fetchCompletedReservations(forUserId userId: String) async throws -> [DonationItem] {
        let all = try await fetchAllItems()
        return all.filter { $0.reserved == userId && $0.closed }
    }
    
    /// Items this user has reserved but which the owner hasn't closed out yet.
        /// Used on the person's own profile so they can find their way back to an
        /// active reservation (e.g. to cancel it) without hunting through search.
        func fetchActiveReservations(forUserId userId: String) async throws -> [DonationItem] {
            let all = try await fetchAllItems()
            return all.filter { $0.reserved == userId && !$0.closed }
        }

        /// Filters open items to those matching a given year level, using
        /// DonationItem.matchesYearLevel — items with no suggested range set are
        /// treated as suitable for any year level, so they still show up here.
        func fetchItems(forYearLevel year: Int) async throws -> [DonationItem] {
            let all = try await fetchAllItems()
            return all.filter { !$0.closed && $0.matchesYearLevel(year) }
        }

    /// Fetches a single user profile by uid — used by AnotherProfileView.
    func fetchUser(id: String) async throws -> AppUser? {
        let doc = try await db.collection("users").document(id).getDocument()
        return try doc.data(as: AppUser.self)
    }

    /// result.js "Users" category: browse all user profiles instead of items.
    func fetchAllUsers() async throws -> [AppUser] {
        let snapshot = try await db.collection("users").getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: AppUser.self) }
    }

    // MARK: - Write

    /// upload.js: create a new donation item. Caller uploads the image first
    /// via StorageService, then passes the resulting URL in here.
    func createItem(_ item: DonationItem) async throws {
        _ = try db.collection("items").addDocument(from: item)
    }

    // MARK: - State transitions (product_info.js button logic)

    func reserve(itemId: String, byUserId userId: String, reserverName: String) async throws {
        try await db.collection("items").document(itemId).updateData([
            "reserved": userId,
            "reservedName": reserverName,
        ])
    }

    func cancelReservation(itemId: String) async throws {
        try await db.collection("items").document(itemId).updateData([
            "reserved": FieldValue.delete(),
            "reservedName": FieldValue.delete(),
        ])
    }

    func closeItem(itemId: String) async throws {
        try await db.collection("items").document(itemId).updateData([
            "closed": true
        ])
    }

    /// Submits a rating: updates the item's own rating, and rolls it into
    /// the owning user's running average (mirrors the ratingSum/ratingCount
    /// logic in product_info.js).
    func submitRating(itemId: String, ownerUserId: String, rating: Int) async throws {
        let userRef = db.collection("users").document(ownerUserId)
        let itemRef = db.collection("items").document(itemId)

        let userSnapshot = try await userRef.getDocument()
        let currentUser = try userSnapshot.data(as: AppUser.self)

        let newSum = (currentUser.ratingSum ?? 0) + Double(rating)
        let newCount = (currentUser.ratingCount ?? 0) + 1
        let newAverage = newSum / Double(newCount)

        try await userRef.updateData([
            "ratingSum": newSum,
            "ratingCount": newCount,
            "rating": newAverage,
        ])
        try await itemRef.updateData([
            "rating": rating
        ])
    }
}
