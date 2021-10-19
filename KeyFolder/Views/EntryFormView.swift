//
//  EditEntryView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct EntryFormView: View {
    @State var name = ""
    @State var folderIndex = 0
    @Binding var isShowing: Bool

    let folders: [Folder]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                        .autocapitalization(.none)
                }
                Section(header: Text("Folder")) {
                    Picker(selection: $folderIndex) {
                        ForEach(0..<folders.count) { index in
                            Text(folders[index].name)
                        }
                    } label: {
                        Text("Folder")
                    }
                }
            }
            .navigationBarTitle("Edit entry", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: {
                }) {
                    Image(systemName: "checkmark")
                })
        }
    }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView(isShowing: .constant(false), folders: [])
    }
}
