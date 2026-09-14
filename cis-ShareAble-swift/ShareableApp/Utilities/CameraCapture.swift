import SwiftUI
import UIKit
import PhotosUI

/// Wraps UIImagePickerController in camera mode. PhotosPicker (used elsewhere
/// for the library) doesn't support camera capture, so this fills that gap —
/// used by UploadView (item photo) and EditProfileView (profile photo).
struct CameraCapture: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraCapture

        init(_ parent: CameraCapture) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let edited = info[.editedImage] as? UIImage {
                parent.image = edited
            } else if let original = info[.originalImage] as? UIImage {
                parent.image = original
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

/// Small helper so both UploadView and EditProfileView can offer "Take Photo"
/// / "Choose from Library" with the same trigger + dialog + sheet pattern,
/// instead of duplicating the plumbing in each screen.
struct PhotoSourceButton<Label: View>: View {
    @Binding var selectedImage: UIImage?
    @ViewBuilder var label: () -> Label

    @State private var showSourceDialog = false
    @State private var showCamera = false
    @State private var showLibraryPicker = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var cameraUnavailableAlert = false

    var body: some View {
        Button {
            showSourceDialog = true
        } label: {
            label()
        }
        .confirmationDialog("Add Photo", isPresented: $showSourceDialog, titleVisibility: .visible) {
            Button("Take Photo") {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCamera = true
                } else {
                    cameraUnavailableAlert = true
                }
            }
            Button("Choose from Library") {
                showLibraryPicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraCapture(image: $selectedImage)
                .ignoresSafeArea()
        }
        .photosPicker(isPresented: $showLibraryPicker, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
        .alert("Camera Unavailable", isPresented: $cameraUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This device doesn't have a camera available (this is expected on the iOS Simulator — test on a physical device).")
        }
    }
}
