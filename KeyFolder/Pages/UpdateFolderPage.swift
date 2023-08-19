//
//  UpdateFolderPage.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/19.
//

import SwiftUI

struct UpdateFolderPage: View {
  @EnvironmentObject private var store: Store

  @Binding var isShowing: Bool

  @State var name = ""

  var body: some View {
    NavigationView {
      FolderForm(name: $name)
        .navigationBarTitle("Edit folder", displayMode: .inline)
        .navigationBarItems(
          leading: Button(
            action: {
              isShowing = false
            },
            label: {
              Image(systemName: "xmark")
            }
          ),
          trailing: Button(
            action: {
              store.updateFolder(name: name)
              isShowing = false
            },
            label: {
              Image(systemName: "checkmark")
            }
          ).disabled(
            name.isEmpty || store.folders.contains { $0.name == name }
          )
        )
    }
  }
}

struct UpdateFolderPage_Previews: PreviewProvider {
  static var previews: some View {
    UpdateFolderPage(isShowing: .constant(true))
  }
}
