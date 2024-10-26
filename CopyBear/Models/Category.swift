//
//  Category.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import Foundation

public class Category {
  let type: CopyItemType
  var items: [CopyItem]

  init(type: CopyItemType) {
    self.type = type
    self.items = []
  }

  func addItem(_ item: CopyItem) {
    items.insert(item, at: 0)
  }
}
