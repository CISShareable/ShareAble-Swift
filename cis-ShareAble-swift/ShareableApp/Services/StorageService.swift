import Foundation
import FirebaseStorage
import UIKit

/// Replaces the uploadBytesResumable / getDownloadURL logic duplicated in
/// upload.js and editProfile.js.
final class StorageService {
    static let shared = StorageService()
    private let storage = Storage.storage()
    private init() {}

    enum StorageError: LocalizedError {
        case invalidImage
        var errorDescription: String? {
            "Couldn't process that image. Please try a different photo."
        }
    }

    /// Uploads a donation item photo. Path convention: "items/{uuid}.jpg"
    func uploadItemImage(_ image: UIImage) async throws -> URL {
        try await upload(image: image, pathPrefix: "items")
    }

    /// Uploads a profile photo. Path convention: "profile/{uuid}.jpg"
    func uploadProfileImage(_ image: UIImage) async throws -> URL {
        try await upload(image: image, pathPrefix: "profile")
    }

    private func upload(image: UIImage, pathPrefix: String) async throws -> URL {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.invalidImage
        }
        let filename = "\(UUID().uuidString).jpg"
        let ref = storage.reference().child("\(pathPrefix)/\(filename)")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(data, metadata: metadata)
        return try await ref.downloadURL()
    }
}
