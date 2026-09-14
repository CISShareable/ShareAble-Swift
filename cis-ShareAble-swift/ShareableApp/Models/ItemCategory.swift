import Foundation

/// Single source of truth for item categories, used by both UploadView's
/// picker and SearchView's "Browse by category" tiles. Previously these two
/// screens had separate, mismatched category lists (Upload offered
/// "Electronics"/"Furniture"/"Other", Search only knew about a different set)
/// — this fixes that by giving both screens the same list.
///
/// `id` is the raw value stored in the `category` field on `items/{itemId}`
/// documents — keep this stable, since changing it would orphan existing
/// items under a category nothing selects for anymore. `displayName` is
/// purely presentational and safe to reword any time.
struct ItemCategory: Identifiable, Hashable {
    let id: String
    let displayName: String

    static let all: [ItemCategory] = [
        ItemCategory(id: "Books", displayName: "Books"),
        ItemCategory(id: "Clothing", displayName: "Clothing"),
        ItemCategory(id: "Educational", displayName: "Educational"),
        ItemCategory(id: "Food", displayName: "Food"),
        ItemCategory(id: "ForChildren", displayName: "For Children"),
        ItemCategory(id: "SportsEquipment", displayName: "Sports Equipment"),
        ItemCategory(id: "Toys", displayName: "Toys"),
        ItemCategory(id: "Furniture", displayName: "Furniture"),
        ItemCategory(id: "Electronics", displayName: "Electronics"),
        ItemCategory(id: "Stationery", displayName: "Stationery"),
        ItemCategory(id: "HouseholdItems", displayName: "Household Items"),
        ItemCategory(id: "Others", displayName: "Others"),
    ]

    /// Looks up the display name for a raw category id stored in Firestore.
    /// Falls back to the raw id itself for any legacy/unrecognized value
    /// already sitting in the database, so nothing renders blank.
    static func displayName(for id: String) -> String {
        all.first(where: { $0.id == id })?.displayName ?? id
    }
}

