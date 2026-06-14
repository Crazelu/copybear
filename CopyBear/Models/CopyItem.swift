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

  static func == (lhs: CopyItem, rhs: CopyItem) -> Bool {
    lhs.type == rhs.type &&
    lhs.data == rhs.data &&
    lhs.fileUrl == rhs.fileUrl &&
    lhs.name == rhs.name
  }
}
