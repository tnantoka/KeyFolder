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
                    Image(systemName: "folder")
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
                Button(action: {}) {
                Image(systemName: "plus")
                }
                Button(action: {}) {
                Image(systemName: "pencil")
                }
                Button(action: {}) {
                Image(systemName: "trash")
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
