//
//  Entry.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import Foundation

struct Entry {
    let name: String
    
    static func all(for folder: Folder) -> [Entry] {
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderURL = documentsURL.appendingPathComponent("folders").appendingPathComponent(folder.name)
            if FileManager.default.fileExists(atPath: folderURL.path) {
                do {
                    return try FileManager.default.contentsOfDirectory(atPath: folderURL.path).map { name in
                        Entry(name: name)
                    }
                } catch {
                    return []
                }
            }
        }
        return []
    }
}
