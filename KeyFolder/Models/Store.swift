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
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyyMMddHHmmss"

            addEntry(folder: folder, data: data, name: "\(formatter.string(from: Date())).png")
        }
    }
    
    func addEntry(folder: Folder, imageURL: URL) {
        if let data = try? Data(contentsOf: imageURL) {
            addEntry(folder: folder, data: data, name: imageURL.lastPathComponent)
        }
    }

    func addEntry(folder: Folder, movieURL: URL) {
        if let data = try? Data(contentsOf: movieURL) {
            addEntry(folder: folder, data: data, name: movieURL.lastPathComponent)
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
    
    func updateEntry(name: String, folderId: String) {
        guard let entry = entries.first(where: { e in e.isSelected }) else { return }
        guard let folder = folders.first(where: { f in f.id == folderId }) else { return }
        self.entries = entries.map { e in
            if e.id == entry.id {
                return e.update(name: name, folder: folder)
            } else {
                return e
            }
        }
    }
}
