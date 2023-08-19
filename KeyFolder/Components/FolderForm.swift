//
//  FolderForm.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/19.
//

import SwiftUI

struct FolderForm: View {
  @Binding var name: String

  @FocusState private var isFocused

  var body: some View {
    Form {
      Section(header: Text("Name")) {
        TextField("Name", text: $name)
          .autocapitalization(.none)
          .focused($isFocused)
      }
    }
    .onAppear {
      isFocused = true
    }
  }
}

struct FolderForm_Previews: PreviewProvider {
  static var previews: some View {
    FolderForm(name: .constant(""))
  }
}
