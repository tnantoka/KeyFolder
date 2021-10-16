//
//  EntryListView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct EntryListView: View {
    @State private var entries: [Entry] = []
    
    let folder: Folder

    var body: some View {
        List(entries, id: \.name) { entry in
            Button {

            } label: {
                HStack {
                    if (entry.isMovie) {
                        Image(systemName: "play.rectangle")
                    } else {
                        Image(systemName: "photo")
                    }
                    Text(entry.name)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Entries", displayMode: .inline)
        .navigationBarItems(
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
            entries = Entry.all(for: folder)
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
