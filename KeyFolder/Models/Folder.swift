//
//  Folder.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import Foundation

struct Folder {
    let id: String
    let name: String
    let isSelected: Bool
    
    init(name: String) {
        self.init(id: UUID().uuidString, name: name, isSelected: false)
    }

    init(id: String, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }

    static func all() -> [Folder] {
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let foldersURL = documentsURL.appendingPathComponent("folders")
            if FileManager.default.fileExists(atPath: foldersURL.path) {
                do {
                    return try FileManager.default.contentsOfDirectory(atPath: foldersURL.path).map { name in
                        Folder(name: name)
                    }
                } catch {
                    return []
                }
            }
        }
        return []
    }
}
