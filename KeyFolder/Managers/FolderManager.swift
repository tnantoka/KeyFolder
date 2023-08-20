//
//  FolderManager.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/20.
//

import Foundation

struct FolderManager {
  func create(name: String) -> Folder {
    let folder = Folder(name: name)
    try? FileManager.default.createDirectory(at: folder.url(), withIntermediateDirectories: false)
    return folder
  }

  func listAll() -> [Folder] {
    if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first
    {
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
