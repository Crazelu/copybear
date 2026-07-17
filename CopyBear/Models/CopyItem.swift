//
//  CopyItem.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import Foundation

struct CopyItem: Equatable {
  let type: CopyItemType
  let data: Data
  let fileUrl: Data?
  let name: String?
  var date: Date
  var isPinned: Bool = false

  init(type: CopyItemType, data: Data) {
    self.type = type
    self.data = data
    self.fileUrl = nil
    self.name = nil
    self.date = Date()
  }

  init(type: CopyItemType, data: Data, name: String?) {
    self.type = type
    self.data = data
    self.fileUrl = nil
    self.name = name
    self.date = Date()
  }

  init(type: CopyItemType, data: Data, fileUrl: Data?) {
    self.type = type
    self.data = data
    self.fileUrl = fileUrl
    self.name = nil
    self.date = Date()
  }

  init(type: CopyItemType, data: Data, fileUrl: Data?, name: String?) {
    self.type = type
    self.data = data
    self.fileUrl = fileUrl
    self.name = name
    self.date = Date()
  }

  init(type: CopyItemType, data: Data, name: String) {
    self.type = type
    self.data = data
    self.fileUrl = nil
    self.name = name
    self.date = Date()
  }

  // Content-based match for dedup and lookups; ignores date and pin state.
  // Full (synthesized) == is left intact so SwiftUI can detect pin/date changes.
  func matches(_ other: CopyItem) -> Bool {
    type == other.type &&
    data == other.data &&
    fileUrl == other.fileUrl &&
    name == other.name
  }
}
