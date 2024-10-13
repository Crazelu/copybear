//
//  Category.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import Foundation

struct Category {
  let type: CopyItemType
  var items: [Data]

  mutating func addItem(_ data: Data) {
    items.append(data)
  }
}
