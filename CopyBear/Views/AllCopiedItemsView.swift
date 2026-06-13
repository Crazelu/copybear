//
//  AllCopiedItems.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import SwiftUI

struct AllCopiedItemsView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel
  
  let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible())
  ]

  private var items: [CopyItem] {
    vm.isSearching ? vm.searchResults : vm.copiedItems
  }

  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(0..<items.count, id: \.self) { index in
        CopyItemView(
          item: items[index],
          backgroundColor: index.color
        )
      }
    }
  }
}
