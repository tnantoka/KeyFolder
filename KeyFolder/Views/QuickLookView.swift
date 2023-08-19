//
//  QuickLookView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/17.
//

import QuickLook
import SwiftUI

struct QuickLookView: UIViewControllerRepresentable {
  let entries: [Entry]

  @Binding var isPresented: Bool
  @Binding var initialEntryId: String

  func makeUIViewController(context: Context) -> UINavigationController {
    let controller = QLPreviewController()
    controller.dataSource = context.coordinator
    controller.delegate = context.coordinator
    controller.currentPreviewItemIndex =
      entries.firstIndex(where: { entry in
        entry.id == initialEntryId
      }) ?? 0

    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done, target: context.coordinator,
      action: #selector(context.coordinator.dismiss)
    )

    let navigationController = UINavigationController(rootViewController: controller)
    return navigationController
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
  }

  class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {

    let parent: QuickLookView

    init(parent: QuickLookView) {
      self.parent = parent
    }

    func numberOfPreviewItems(
      in controller: QLPreviewController
    ) -> Int {
      return parent.entries.count
    }

    func previewController(
      _ controller: QLPreviewController, previewItemAt index: Int
    ) -> QLPreviewItem {
      return parent.entries[index].url() as NSURL
    }

    func previewController(
      _ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem
    ) -> QLPreviewItemEditingMode {
      return .disabled
    }

    @objc func dismiss() {
      parent.isPresented = false
    }
  }
}

struct QuickLookView_Previews: PreviewProvider {
  static var previews: some View {
    QuickLookView(entries: [], isPresented: .constant(false), initialEntryId: .constant(""))
  }
}
