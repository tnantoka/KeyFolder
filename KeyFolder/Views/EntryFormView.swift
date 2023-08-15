//
//  EditEntryView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct EntryFormView: View {
    @EnvironmentObject private var store: Store

    @State var name = ""
    @State var folderId = ""
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
                Section(header: Text("Folder")) {
                    Picker(selection: $folderId) {
                        ForEach(store.folders, id: \.id) { folder in
                            Text(folder.name)
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
                    store.updateEntry(name: name, folderId: folderId)
                    isShowing = false
                                    }) {
                    Image(systemName: "checkmark")
                }.disabled(name.isEmpty))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                   isFocused = true
                }
            }
        }
    }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView(isShowing: .constant(false))
    }
}
