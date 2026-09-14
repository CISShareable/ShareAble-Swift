import FirebaseFirestore

/// Mirrors the `users/{uid}` Firestore document.
/// Field names match your existing JS (signup.js, editProfile.js, product_info.js)
/// so no backend migration is needed.
struct AppUser: Codable, Identifiable {
    @DocumentID var id: String?          // Firestore doc ID == Firebase Auth uid

    var username: String
    var userId: String                   // duplicated in JS; kept for compatibility
    var email: String
    var phone: String?
    var yearLevel: Int?

    var profileImageUrl: String?

    // Rating fields, aggregated on the user (see product_info.js rating logic)
    var ratingSum: Double?
    var ratingCount: Int?
    var rating: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case userId
        case email
        case phone
        case yearLevel
        case profileImageUrl
        case ratingSum
        case ratingCount
        case rating
    }

    // Custom decoding: the original JS app wrote yearLevel/ratingSum/etc as
    // plain JS numbers, which can land in Firestore as either Int or Double
    // depending on how they were computed. Swift's synthesized Decodable is
    // strict about this and throws on a type mismatch (this is almost
    // certainly why profile fetches were failing). This decoder accepts
    // either numeric representation for every numeric field.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        yearLevel = try container.decodeFlexibleInt(forKey: .yearLevel)
        profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        ratingSum = try container.decodeFlexibleDouble(forKey: .ratingSum)
        ratingCount = try container.decodeFlexibleInt(forKey: .ratingCount)
        rating = try container.decodeFlexibleDouble(forKey: .rating)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(yearLevel, forKey: .yearLevel)
        try container.encodeIfPresent(profileImageUrl, forKey: .profileImageUrl)
        try container.encodeIfPresent(ratingSum, forKey: .ratingSum)
        try container.encodeIfPresent(ratingCount, forKey: .ratingCount)
        try container.encodeIfPresent(rating, forKey: .rating)
    }

    /// Memberwise init, still needed since we defined a custom Decodable init above.
    init(
        id: String? = nil,
        username: String,
        userId: String,
        email: String,
        phone: String? = nil,
        yearLevel: Int? = nil,
        profileImageUrl: String? = nil,
        ratingSum: Double? = nil,
        ratingCount: Int? = nil,
        rating: Double? = nil
    ) {
        self._id = DocumentID(wrappedValue: id)
        self.username = username
        self.userId = userId
        self.email = email
        self.phone = phone
        self.yearLevel = yearLevel
        self.profileImageUrl = profileImageUrl
        self.ratingSum = ratingSum
        self.ratingCount = ratingCount
        self.rating = rating
    }
}

private extension KeyedDecodingContainer where K == AppUser.CodingKeys {
    /// Accepts Int, Double, or a numeric String for the given key.
    /// Note: `try?` flattens nested optionals in Swift 5+, so `value` below
    /// is already the unwrapped, non-optional type — no `.map`/`.flatMap` needed.
    func decodeFlexibleInt(forKey key: K) throws -> Int? {
        if let value = try? decodeIfPresent(Int.self, forKey: key) { return value }
        if let value = try? decodeIfPresent(Double.self, forKey: key) { return Int(value) }
        if let value = try? decodeIfPresent(String.self, forKey: key) { return Int(value) }
        return nil
    }

    /// Accepts Double, Int, or a numeric String for the given key.
    func decodeFlexibleDouble(forKey key: K) throws -> Double? {
        if let value = try? decodeIfPresent(Double.self, forKey: key) { return value }
        if let value = try? decodeIfPresent(Int.self, forKey: key) { return Double(value) }
        if let value = try? decodeIfPresent(String.self, forKey: key) { return Double(value) }
        return nil
    }
}
