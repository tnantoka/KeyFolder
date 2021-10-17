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
    @State private var isPicking: Bool = false

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
                    Button(action: {                        isPicking = true
}) {
                    Image(systemName: "plus")
                    }
                } else {
                    Button(action: {
                        isEditing = true
                    }) {
                    Image(systemName: "pencil")
                    }
                    Button(action: {}) {
                    Image(systemName: "trash")
                    }
                }
            })
        .fullScreenCover(isPresented: $isPreviwing) {
            QuickLookView(entries: entries, isPresented: $isPreviwing, initialEntryId: $previwingId)
        }
        .sheet(isPresented: $isEditing) {
            EntryFormView(name: entries.first { entry in entry.isSelected }?.name ?? "", isShowing: $isEditing, folders: store.folders)
        }
        .sheet(isPresented: $isPicking) {
            ImagePickerView(isPresented: $isPicking) { image in
                print(image)
            }
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
