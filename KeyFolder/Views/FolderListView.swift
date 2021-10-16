//
//  FolderListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct FolderListView: View {
    @State private var folders: [Folder] = []
    
    var body: some View {
        List(folders, id: \.name) { folder in
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
        .onAppear {
            folders = Folder.all()
        }
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderListView()
        }
    }
}
