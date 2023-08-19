//
//  CreateFolderPage.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/19.
//

import SwiftUI

struct CreateFolderPage: View {
  @EnvironmentObject private var store: Store

  @State var name = ""
  @Binding var isShowing: Bool

  var body: some View {
    NavigationView {
      FolderForm(name: $name)
        .navigationBarTitle("New folder", displayMode: .inline)
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
              store.createFolder(name: name)
              isShowing = false
            },
            label: {
              Image(systemName: "checkmark")
            }
          )
          .disabled(
            name.isEmpty || store.folders.contains { $0.name == name }
          )
        )
    }
  }
}

struct CreateFolderPage_Previews: PreviewProvider {
  static var previews: some View {
    CreateFolderPage(isShowing: .constant(true))
  }
}
