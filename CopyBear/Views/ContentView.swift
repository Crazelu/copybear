//
//  ContentView.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel

  var body: some View {
    ZStack {
      switch vm.navigationDestination {
      case .home: HomeView()
      case .category:
        if vm.selectedCategory != nil {
          CategoryContentView(category: .init(get: {
            vm.selectedCategory ?? Category(type: .other)
          }, set: { category in
            vm.selectedCategory = category
          }))
        } else {
          HomeView()
        }
      }
    }
    .padding()
      .frame(width: 430, height: 400)
      .background(Constants.Colors.background)
      .task {
        vm.listenForCopyEvent()
      }
  }
}
