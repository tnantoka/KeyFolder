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

  func url() -> URL {
    if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first
    {
      return documentsURL.appendingPathComponent("folders").appendingPathComponent(name)
    }
    return URL(string: "")!
  }

  func destroy() {
    try? FileManager.default.removeItem(at: url())
  }

  func update(name: String) -> Folder {
    let folder = Folder(id: id, name: name, isSelected: isSelected)
    try? FileManager.default.moveItem(at: url(), to: folder.url())
    return folder
  }
}
