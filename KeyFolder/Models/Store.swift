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
}
