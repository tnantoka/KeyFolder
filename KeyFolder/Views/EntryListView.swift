//
//  EntryListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct EntryListView: View {
    @EnvironmentObject private var store: Store

    let folder: Folder

    var body: some View {
        let entries = store.entries.filter { entry in
            entry.folderId == folder.id
        }
        List(entries, id: \.id) { entry in
            Button {

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
                    Button(action: {}) {
                    Image(systemName: "plus")
                    }
                } else {
                    Button(action: {}) {
                    Image(systemName: "pencil")
                    }
                    Button(action: {}) {
                    Image(systemName: "trash")
                    }
                }
            })
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryListView(folder: Folder(name: "example"))
        }
    }
}
