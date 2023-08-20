//
//  DocumentPickerView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {

  let onPickImage: (URL) -> Void
  let onPickMovie: (URL) -> Void

  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let controller = UIDocumentPickerViewController(forOpeningContentTypes: [
      .image, .movie, .pdf, .text,
    ])
    controller.allowsMultipleSelection = true

    controller.delegate = context.coordinator

    return controller
  }

  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context)
  {
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }

  class Coordinator: NSObject, UIDocumentPickerDelegate {
    let parent: DocumentPicker

    init(parent: DocumentPicker) {
      self.parent = parent
    }

    func documentPicker(
      _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
    ) {
      for url in urls {
        guard let mimeType = UTType(filenameExtension: url.pathExtension)?.preferredMIMEType else {
          return
        }

        if mimeType.hasPrefix("image") {
          parent.onPickImage(url)
        } else {
          parent.onPickMovie(url)
        }
      }
    }
  }
}

struct DocumentPicker_Previews: PreviewProvider {
  static var previews: some View {
    DocumentPicker(onPickImage: { _ in }, onPickMovie: { _ in })
  }
}
