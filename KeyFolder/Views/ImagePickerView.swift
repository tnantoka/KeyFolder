//
//  ImagePickerView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/17.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {

    @Binding var isPresented: Bool

    let onPickImage: (UIImage) -> Void
    let onPickMovie: (URL) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()

        controller.delegate = context.coordinator
        controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        controller.allowsEditing = false
        controller.mediaTypes = ["public.image", "public.movie"]

        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onPickImage(image)
            } else if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                parent.onPickMovie(url)
            }
            parent.isPresented = false
        }
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(isPresented: .constant(false), onPickImage: { _ in }, onPickMovie: { _ in })
    }
}
