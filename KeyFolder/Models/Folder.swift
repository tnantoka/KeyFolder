//
//  Folder.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import Foundation

struct Folder {
    let id = UUID().uuidString
    let name: String
    
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
