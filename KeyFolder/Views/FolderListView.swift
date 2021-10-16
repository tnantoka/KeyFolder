//
//  FolderListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct FolderListView: View {
    @EnvironmentObject private var store: Store

    var body: some View {
        List(store.folders, id: \.id) { folder in
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
            leading: Button(action: {}) {
                Image(systemName: "ellipsis")
            },
            trailing: HStack {
                if store.folders.first { folder in folder.isSelected } == nil {
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

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderListView()
        }
    }
}
