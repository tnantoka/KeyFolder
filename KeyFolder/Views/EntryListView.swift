//
//  EntryListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct EntryListView: View {
    @EnvironmentObject private var store: Store
    @State private var isPreviwing: Bool = false
    @State private var previwingId = ""
    @State private var isEditing: Bool = false
    @State private var isPickingPhotos: Bool = false
    @State private var isPickingFiles: Bool = false
    @State private var isDeleting: Bool = false
    @State private var isShowingMenu: Bool = false

    let folder: Folder

    var body: some View {
        let entries = store.entries.filter { entry in
            entry.folder.id == folder.id
        }
        List(entries, id: \.id) { entry in
            Button {
                previwingId = entry.id
                isPreviwing = true
            } label: {
                HStack {
                    Button {
                        store.select(entry: entry, isSelected: !entry.isSelected)
                    } label: {
                        if (entry.isSelected) {
                            Image(systemName: "checkmark.circle")
                        } else {
                            if (entry.isMovie) {
                                Image(systemName: "play.rectangle")
                            } else {
                                Image(systemName: "photo")
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 32)
                    Text(entry.name)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Entries", displayMode: .inline)
        .navigationBarItems(
            trailing: HStack {
                if entries.first { folder in folder.isSelected } == nil {
                    Button(action: {
                        isShowingMenu = true
                    }) {
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
        .fullScreenCover(isPresented: $isPreviwing) {
            QuickLookView(entries: entries, isPresented: $isPreviwing, initialEntryId: $previwingId)
        }
        .sheet(isPresented: $isEditing) {
            let entry = entries.first { entry in entry.isSelected }
            EntryFormView(name: entry?.name ?? "", folderId: entry?.folder.id ?? "", isShowing: $isEditing)
        }
        .sheet(isPresented: $isPickingPhotos) {
            ImagePickerView(isPresented: $isPickingPhotos, onPickImage: { image
                in
                store.addEntry(folder: folder, image: image)
            }, onPickMovie: { url in
                store.addEntry(folder: folder, movieURL: url)
            })
        }
        .sheet(isPresented: $isPickingFiles) {
            DocumentPickerView(onPickImage: { url in
                store.addEntry(folder: folder, imageURL: url)
            }, onPickMovie: { url in
                store.addEntry(folder: folder, movieURL: url)
            })
        }
        .alert(isPresented: $isDeleting) {
            Alert(title: Text("Delete"),
                  message: Text("Are you sure?"),
                    primaryButton: .destructive(Text("Delete")) {
                if let entry = entries.first(where: { entry in entry.isSelected }) {
                    store.delete(entry: entry)
                }
            }, secondaryButton: .cancel(Text("Cancel")))
        }
        .actionSheet(isPresented: $isShowingMenu) {
            ActionSheet(title: Text("Menu"), buttons: [
                .default(Text("From photo library")) {
                    isPickingPhotos = true
                },
                .default(Text("From files")) {
                    isPickingFiles = true
                },
                .cancel(Text("Cancel"))
            ])
        }
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryListView(folder: Folder(name: "example"))
        }
    }
}
