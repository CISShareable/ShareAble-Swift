import FirebaseFirestore

/// Mirrors the `items/{itemId}` Firestore document.
struct DonationItem: Codable, Identifiable {
    @DocumentID var id: String?

    var name: String
    var quantity: String                 // stored as free text in the JS (e.g. "3 units")
    var category: String
    var time: String                     // formatted date string, e.g. "2026-08-08"

    var userId: String                   // owner's uid
    var username: String                 // denormalized owner username, for display

    var itemImageUrl: String

    var closed: Bool
    var reserved: String?                // uid of the reserving user, or nil
    var reservedName: String?

    var rating: Int?                     // buyer's rating of this specific transaction

    /// Suggested year level range this item is appropriate for
    var suggestedYearLevelMin: Int?
    var suggestedYearLevelMax: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quantity
        case category
        case time
        case userId
        case username
        case itemImageUrl
        case closed
        case reserved
        case reservedName
        case rating
        case suggestedYearLevelMin
        case suggestedYearLevelMax
    }

    // Custom decoding for the same reason as AppUser: `rating` was written by
    // the JS app as a plain number that can land in Firestore as either Int
    // or Double, and older documents may be missing fields entirely (e.g.
    // `closed` defaulting to false if never explicitly set). This tolerates
    // both instead of throwing a decode error and silently dropping the item
    // from every list in the app.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        quantity = try container.decodeIfPresent(String.self, forKey: .quantity) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        time = try container.decodeIfPresent(String.self, forKey: .time) ?? ""
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        itemImageUrl = try container.decodeIfPresent(String.self, forKey: .itemImageUrl) ?? ""
        closed = try container.decodeIfPresent(Bool.self, forKey: .closed) ?? false
        reserved = try container.decodeIfPresent(String.self, forKey: .reserved)
        reservedName = try container.decodeIfPresent(String.self, forKey: .reservedName)
        rating = try container.decodeFlexibleInt(forKey: .rating)
        suggestedYearLevelMin = try container.decodeFlexibleInt(forKey: .suggestedYearLevelMin)
        suggestedYearLevelMax = try container.decodeFlexibleInt(forKey: .suggestedYearLevelMax)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(category, forKey: .category)
        try container.encode(time, forKey: .time)
        try container.encode(userId, forKey: .userId)
        try container.encode(username, forKey: .username)
        try container.encode(itemImageUrl, forKey: .itemImageUrl)
        try container.encode(closed, forKey: .closed)
        try container.encodeIfPresent(reserved, forKey: .reserved)
        try container.encodeIfPresent(reservedName, forKey: .reservedName)
        try container.encodeIfPresent(rating, forKey: .rating)
        try container.encodeIfPresent(suggestedYearLevelMin, forKey: .suggestedYearLevelMin)
        try container.encodeIfPresent(suggestedYearLevelMax, forKey: .suggestedYearLevelMax)
    }

    /// Memberwise init, still needed since we defined a custom Decodable init above.
    init(
        id: String? = nil,
        name: String,
        quantity: String,
        category: String,
        time: String,
        userId: String,
        username: String,
        itemImageUrl: String,
        closed: Bool,
        reserved: String? = nil,
        reservedName: String? = nil,
        rating: Int? = nil,
        suggestedYearLevelMin: Int? = nil,
        suggestedYearLevelMax: Int? = nil
    ) {
        self._id = DocumentID(wrappedValue: id)
        self.name = name
        self.quantity = quantity
        self.category = category
        self.time = time
        self.userId = userId
        self.username = username
        self.itemImageUrl = itemImageUrl
        self.closed = closed
        self.reserved = reserved
        self.reservedName = reservedName
        self.rating = rating
        self.suggestedYearLevelMin = suggestedYearLevelMin
        self.suggestedYearLevelMax = suggestedYearLevelMax
    }
}

private extension KeyedDecodingContainer where K == DonationItem.CodingKeys {
    /// Accepts Int, Double, or a numeric String for the given key.
    /// Note: `try?` flattens nested optionals in Swift 5+, so `value` below
    /// is already the unwrapped, non-optional type — no `.map`/`.flatMap` needed.
    func decodeFlexibleInt(forKey key: K) throws -> Int? {
        if let value = try? decodeIfPresent(Int.self, forKey: key) { return value }
        if let value = try? decodeIfPresent(Double.self, forKey: key) { return Int(value) }
        if let value = try? decodeIfPresent(String.self, forKey: key) { return Int(value) }
        return nil
    }
}

extension DonationItem {
    /// Convenience: who is viewing this item, relative to ownership/reservation state.
    /// Mirrors the branching logic in product_info.js (owner vs buyer, rated vs not, etc).
    enum ViewerRole {
        case ownerCanClose
        case ownerAwaitingReturn(reservedByName: String)
        case ownerSeesRating(Double)
        case buyerCanReserve
        case buyerCanCancelReserve
        case buyerCanRate
        case buyerSeesOwnRating(Int)
        case closed
    }

    func viewerRole(currentUserId: String) -> ViewerRole {
        if userId == currentUserId, let rating, rating >= 1 {
            return .ownerSeesRating(Double(rating))
        }
        if let rating, rating >= 1 {
            return .buyerSeesOwnRating(rating)
        }
        if let reserved, userId == currentUserId {
            return .ownerAwaitingReturn(reservedByName: reservedName ?? "someone")
        }
        if reserved == currentUserId, closed {
            return .buyerCanRate
        }
        if reserved == currentUserId {
            return .buyerCanCancelReserve
        }
        if userId == currentUserId, !closed {
            return .ownerCanClose
        }
        if closed {
            return .closed
        }
        return .buyerCanReserve
    }

    /// "Year 7", "Year 7–9", or nil if no suggested range was set.
    var suggestedYearLevelDisplay: String? {
        switch (suggestedYearLevelMin, suggestedYearLevelMax) {
        case let (.some(min), .some(max)) where min == max:
            return "Year \(min)"
        case let (.some(min), .some(max)):
            return "Year \(min)–\(max)"
        case let (.some(min), nil):
            return "Year \(min)+"
        case let (nil, .some(max)):
            return "Up to Year \(max)"
        case (nil, nil):
            return nil
        }
    }
    
    /// Whether this item is suitable for the given year level. Items with no
        /// suggested range set (both fields nil) are treated as suitable for any
        /// year level, so they still surface when someone filters by year —
        /// otherwise every item uploaded before this feature existed (or by
        /// someone who skipped it) would silently disappear from filtered results.
        func matchesYearLevel(_ year: Int) -> Bool {
            switch (suggestedYearLevelMin, suggestedYearLevelMax) {
            case (nil, nil):
                return true
            case let (.some(min), .some(max)):
                return year >= min && year <= max
            case let (.some(min), nil):
                return year >= min
            case let (nil, .some(max)):
                return year <= max
            }
        }
}

