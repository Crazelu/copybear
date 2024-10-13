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

  private func getCardColor(for index: Int) -> Color {
    let i = (index + 1) % 6
    return switch i {
      case 1: Constants.Colors.blue
      case 2: Constants.Colors.pink
      case 3: Constants.Colors.purple
      case 4: Constants.Colors.yellow
      case 5: Constants.Colors.green
      default:Constants.Colors.orange
    }
  }

  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(0..<vm.allCopies.count, id: \.self) { index in
        CopyItemView(
          item: vm.allCopies[index],
          backgroundColor: getCardColor(for: index)
        )
      }
    }
  }
}
