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
    context.coordinator.controller = controller

    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done, target: context.coordinator,
      action: #selector(context.coordinator.dismiss)
    )

    // NOTE: For when the app becomes inactive during the preview
    NotificationCenter.default.addObserver(
      controller,
      selector: #selector(controller.reloadData),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
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
    var controller: QLPreviewController?

    init(parent: QuickLookView) {
      self.parent = parent
    }

    func numberOfPreviewItems(
      in controller: QLPreviewController
    ) -> Int {
      return parent.isPresented ? parent.entries.count : 1
    }

    func previewController(
      _ controller: QLPreviewController, previewItemAt index: Int
    ) -> QLPreviewItem {
      if parent.isPresented {
        return parent.entries[index].url() as NSURL
      } else {
        return Bundle.main.url(forResource: "blank", withExtension: "png")! as NSURL
      }
    }

    func previewController(
      _ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem
    ) -> QLPreviewItemEditingMode {
      return .disabled
    }

    @objc func dismiss() {
      parent.isPresented = false
      controller?.reloadData()  // NOTE: For when dismissed in the app
    }
  }
}

struct QuickLookView_Previews: PreviewProvider {
  static var previews: some View {
    QuickLookView(entries: [], isPresented: .constant(false), initialEntryId: .constant(""))
  }
}
