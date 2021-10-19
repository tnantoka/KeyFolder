//
//  FolderListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct FolderListView: View {
    @EnvironmentObject private var store: Store
    @State private var isShowingMenu: Bool = false
    @State private var isEditing: Bool = false
    @State private var isDeleting: Bool = false
    @Binding var isLocked: Bool

    var body: some View {
        List(isLocked ? [] : store.folders, id: \.id) { folder in
            NavigationLink {
                EntryListView(folder: folder)
            } label: {
                HStack {
                    Button {
                        store.select(folder: folder, isSelected: !folder.isSelected)
                    } label: {
                        if (folder.isSelected) {
                            Image(systemName: "checkmark.circle")
                        } else {
                            Image(systemName: "folder")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 32)
                    Text(folder.name)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Folders", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                isShowingMenu = true
            }) {
                Image(systemName: "ellipsis")
            },
            trailing: HStack {
                if store.folders.first { folder in folder.isSelected } == nil {
                    Button(action: {}) {
                    Image(systemName: "plus")
                    }
                } else {
                    Button(action: {
                        isEditing = true
                    }) {
                    Image(systemName: "pencil")
                    }
                    Button(action: {
                        isDeleting = true
                    }) {
                    Image(systemName: "trash")
                    }
                }
            })
        .actionSheet(isPresented: $isShowingMenu) {
            ActionSheet(title: Text("Menu"), buttons: [
                .default(Text("Change passcode")) {
                },
                .default(Text("Info")) {
                },
                .cancel(Text("Cancel"))
            ])
        }
        .alert(isPresented: $isDeleting) {
            Alert(title: Text("Delete"),
                  message: Text("Are you sure?"),
                    primaryButton: .destructive(Text("Delete")) {
                if let folder = store.folders.first(where: { folder in folder.isSelected }) {
                    store.delete(folder: folder)
                }
            }, secondaryButton: .cancel(Text("Cancel")))
        }
        .sheet(isPresented: $isEditing) {
            FolderFormView(mode: .edit, name: store.folders.first { folder in folder.isSelected }?.name ?? "", isShowing: $isEditing)
        }
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderListView(isLocked: .constant(false))
        }
    }
}
