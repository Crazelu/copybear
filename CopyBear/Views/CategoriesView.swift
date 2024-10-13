//
//  CategoriesView.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import SwiftUI

struct CategoriesView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel
  let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible())
  ]
  
  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(0..<vm.allCopies.count, id: \.self) { index in
        
      }
    }
  }
}
