import SwiftUI
import FirebaseAuth
import Combine

/// Replaces upload.html (upload_og.html) + upload.js
struct UploadView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = UploadViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    PhotoSourceButton(selectedImage: $viewModel.selectedImage) {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 180)
                        } else {
                            Label("Add photo", systemImage: "photo.on.rectangle")
                        }
                    }
                }

                Section("Item details") {
                    TextField("Item name", text: $viewModel.itemName)
                    TextField("Quantity", text: $viewModel.quantity)
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(ItemCategory.all) { category in
                            Text(category.displayName).tag(category.id)
                        }
                    }
                }

                Section {
                    Toggle("Specify year levels", isOn: $viewModel.hasYearLevelRange)
                    if viewModel.hasYearLevelRange {
                        Picker("From", selection: $viewModel.minYearLevel) {
                            ForEach(1...13, id: \.self) { year in
                                Text("Year \(year)").tag(year)
                            }
                        }
                        Picker("To", selection: $viewModel.maxYearLevel) {
                            ForEach(1...13, id: \.self) { year in
                                Text("Year \(year)").tag(year)
                            }
                        }
                    }
                } header: {
                    Text("Suggested year levels")
                } footer: {
                    Text("Optional — lets people browsing know which year levels this item best suits, e.g. a Year 7 textbook or Year 1–3 uniform.")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                }

                Section {
                    Button {
                        Task {
                            await viewModel.submit(
                                userId: authService.currentUser?.uid,
                                username: authService.currentUserProfile?.username
                            )
                        }
                    } label: {
                        if viewModel.isSubmitting {
                            ProgressView()
                        } else {
                            Text("Submit")
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isSubmitting)
                }
            }
            .navigationTitle("Upload item")
            .alert("Item uploaded!", isPresented: $viewModel.didSucceed) {
                Button("OK") { viewModel.reset() }
            }
        }
    }
}

@MainActor
final class UploadViewModel: ObservableObject {
    @Published var itemName = ""
    @Published var quantity = ""
    @Published var category = ItemCategory.all.first!.id
    @Published var hasYearLevelRange = false
    @Published var minYearLevel = 1
    @Published var maxYearLevel = 13
    @Published var selectedImage: UIImage?
    @Published var isSubmitting = false
    @Published var errorMessage: String?
    @Published var didSucceed = false

    var isValid: Bool {
        !itemName.isEmpty && !quantity.isEmpty && selectedImage != nil
    }

    /// Mirrors the validation + Storage-then-Firestore sequence in upload.js's
    /// submit_button click handler.
    func submit(userId: String?, username: String?) async {
        errorMessage = nil

        guard let userId, let username else {
            errorMessage = "You must be logged in to upload an item."
            return
        }
        guard let image = selectedImage else {
            errorMessage = "No image uploaded."
            return
        }
        guard !itemName.isEmpty else {
            errorMessage = "Please give your item a name."
            return
        }

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let imageURL = try await StorageService.shared.uploadItemImage(image)

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = formatter.string(from: Date())

            let item = DonationItem(
                name: itemName,
                quantity: quantity,
                category: category,
                time: formattedDate,
                userId: userId,
                username: username,
                itemImageUrl: imageURL.absoluteString,
                closed: false,
                reserved: nil,
                reservedName: nil,
                rating: nil,
                suggestedYearLevelMin: hasYearLevelRange ? min(minYearLevel, maxYearLevel) : nil,
                suggestedYearLevelMax: hasYearLevelRange ? max(minYearLevel, maxYearLevel) : nil
            )
            try await ItemService.shared.createItem(item)
            didSucceed = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func reset() {
        itemName = ""
        quantity = ""
        category = ItemCategory.all.first!.id
        hasYearLevelRange = false
        minYearLevel = 1
        maxYearLevel = 13
        selectedImage = nil
    }
}

