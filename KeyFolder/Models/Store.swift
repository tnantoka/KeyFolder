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
            Entry(id: e.id, name: e.name, folder: e.folder, isSelected: e.id == entry.id ? isSelected : false)
        }
    }
    
    func delete(folder: Folder) {
        self.folders = folders.filter { f in f.id != folder.id }
        self.entries = entries.filter { e in e.folder.id != folder.id }
        folder.destroy()
    }

    func delete(entry: Entry) {
        self.entries = entries.filter { e in e.id != entry.id }
        entry.destroy()
    }
    
    func addEntry(folder: Folder, image: UIImage) {
        if let data = image.pngData() {
            addEntry(folder: folder, data: data, name: "\(UUID().uuidString).png")
        }
    }
    
    func addEntry(folder: Folder, movieURL: URL) {
        if let data = try? Data(contentsOf: movieURL) {
            addEntry(folder: folder, data: data, name: "\(UUID().uuidString).mov")
        }
    }
    
    func addEntry(folder: Folder, data: Data, name: String) {
        try? data.write(to: folder.url().appendingPathComponent(name))
        entries.append(Entry(name: name, folder: folder))
    }
    
    func addFolder(name: String) {
        folders.append(Folder.create(name: name))
    }
    
    func updateFolder(name: String) {
        guard let folder = folders.first(where: { f in f.isSelected }) else { return }
        self.folders = folders.map { f in
            if f.id == folder.id {
                return f.update(name: name)
            } else {
                return f
            }
        }
    }
}
