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
    // Pinned items stay in a pinned section at the front of the list
    let index = item.isPinned ? 0 : (items.firstIndex(where: { !$0.isPinned }) ?? items.count)
    items.insert(item, at: index)
  }
}
