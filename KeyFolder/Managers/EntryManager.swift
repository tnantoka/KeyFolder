//
//  EntryManager.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/20.
//

import Foundation

struct EntryManager {
  let ignoredNames = [".DS_Store"]

  func listAll(for folder: Folder) -> [Entry] {
    let folderURL = folder.url()
    if FileManager.default.fileExists(atPath: folderURL.path) {
      do {
        return try FileManager.default.contentsOfDirectory(atPath: folderURL.path).map { name in
          Entry(name: name, folder: folder)
        }.filter { !ignoredNames.contains($0.name) }
      } catch {
        return []
      }
    }
    return []
  }
}
