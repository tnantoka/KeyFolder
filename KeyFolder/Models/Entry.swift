//
//  Entry.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import Foundation

struct Entry {
    let id: String
    let name: String
    let folder: Folder
    let isSelected: Bool

    var isMovie: Bool {
        return name.hasSuffix(".mp4")
    }
    
    init(name: String, folder: Folder) {
        self.init(id: UUID().uuidString, name: name, folder: folder, isSelected: false)
    }

    init(id: String, name: String, folder: Folder, isSelected: Bool) {
        self.id = id
        self.name = name
        self.folder = folder
        self.isSelected = isSelected
    }
    
    func url() -> URL {
        return folder.url().appendingPathComponent(name)
    }

    func destroy() {
        try? FileManager.default.removeItem(at: url())
    }

    func update(name: String, folder: Folder) -> Entry {
        let entry = Entry(id: id, name: name, folder: folder, isSelected: isSelected)
        try? FileManager.default.moveItem(at: url(), to: entry.url())
        return entry
    }

    static func all(for folder: Folder) -> [Entry] {
        let folderURL = folder.url()
        if FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: folderURL.path).map { name in
                    Entry(name: name, folder: folder)
                }
            } catch {
                return []
            }
        }
        return []
    }
}
