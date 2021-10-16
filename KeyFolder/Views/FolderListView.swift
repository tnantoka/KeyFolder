//
//  FolderListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct FolderListView: View {
    let folders = [
        Folder(name: "example"),
        Folder(name: "test")
    ]
    var body: some View {
        List(folders, id: \.name) { folder in
            NavigationLink {
                EntryListView()
            } label: {
                Text(folder.name)
            }
        }
        .navigationBarTitle("Folders", displayMode: .inline)
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderListView()
        }
    }
}
