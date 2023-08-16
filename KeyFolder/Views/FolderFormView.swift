//
//  EditFolderView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct FolderFormView: View {
  @EnvironmentObject private var store: Store

  enum Mode {
    case new, edit
  }

  let mode: Mode

  @State var name = ""
  @FocusState private var isFocused
  @Binding var isShowing: Bool

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Name")) {
          TextField("Name", text: $name)
            .autocapitalization(.none)
            .focused($isFocused)
        }
      }
      .navigationBarTitle(title, displayMode: .inline)
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
            switch mode {
            case .new:
              store.addFolder(name: name)
            case .edit:
              store.updateFolder(name: name)
            }
            isShowing = false
          },
          label: {
            Image(systemName: "checkmark")
          }
        ).disabled(name.isEmpty)
      )
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
          isFocused = true
        }
      }
    }
  }

  private var title: String {
    switch mode {
    case .new:
      return NSLocalizedString("New folder", comment: "")
    case .edit:
      return NSLocalizedString("Edit folder", comment: "")
    }
  }
}

struct FolderFormView_Previews: PreviewProvider {
  static var previews: some View {
    FolderFormView(mode: .new, name: "name", isShowing: .constant(false))
  }
}
