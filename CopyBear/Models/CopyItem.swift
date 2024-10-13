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

  init(type: CopyItemType, data: Data) {
    self.type = type
    self.data = data
    self.fileUrl = nil
  }

  init(type: CopyItemType, data: Data, fileUrl: Data?) {
    self.type = type
    self.data = data
    self.fileUrl = fileUrl
  }
}
