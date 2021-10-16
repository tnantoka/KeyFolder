//
//  Store.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

class Store: ObservableObject {
    @Published var folders = [Folder]()
    @Published var entries = [Entry]()
    
    init() {
        folders = Folder.all()
        entries = folders.flatMap({ folder in
            Entry.all(for: folder)
        })
        print(entries)
    }
    
    func select(folder: Folder, isSelected: Bool) {
        self.folders = folders.map { f in
            Folder(id: f.id, name: f.name, isSelected: f.id == folder.id ? isSelected : false)
        }
    }
    
    func select(entry: Entry, isSelected: Bool) {
        self.entries = entries.map { e in
            Entry(id: e.id, name: e.name, folderId: e.folderId, isSelected: e.id == entry.id ? isSelected : false)
        }

    }
}
