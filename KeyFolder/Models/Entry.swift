//
//  Entry.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import Foundation
import UniformTypeIdentifiers

struct Entry {
  static let ignoredNames = [".DS_Store"]

  let id: String
  let name: String
  let folder: Folder
  let isSelected: Bool

  var icon: String {
    let defaultIcon = "questionmark.square"
    guard let mimeType = UTType(filenameExtension: url().pathExtension)?.preferredMIMEType else {
      return defaultIcon
    }

    if mimeType.hasPrefix("video") {
      return "play.rectangle"
    } else if mimeType.hasPrefix("image") {
      return "photo"
    } else if mimeType == "text/plain" {
      return "doc.text"
    } else if mimeType == "application/pdf" {
      return "doc.richtext"
    } else {
      return defaultIcon
    }
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
        }.filter { !ignoredNames.contains($0.name) }
      } catch {
        return []
      }
    }
    return []
  }
}
