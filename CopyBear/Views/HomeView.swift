//
//  MenuBarContent.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel
  @State private var searchText = ""
  
  @ViewBuilder private var contentView: some View {
    switch vm.viewType {
    case .all:
      AllCopiedItemsView()
    case .categories:
      if vm.isSearching {
        AllCopiedItemsView()
      } else {
        CategoriesView()
      }
    }
  }
  
  var showEmptyState: Bool {
    vm.isSearching ? vm.searchResults.isEmpty : vm.copiedItems.isEmpty && vm.viewType == .all
  }
  
  var body: some View {
    ZStack{
      VStack(alignment: .leading, spacing: 20) {
        CopyBearLogoHeader()
        
        HStack(alignment: .center) {
          if vm.isSearching {
            HStack {
              Image(systemName: "magnifyingglass")
                .foregroundStyle(Constants.Colors.dropdownMenuBackground)
              TextField("Search...", text: $searchText)
                .textFieldStyle(.plain)
            }
            .padding(8)
            .background(Constants.Colors.keyBackgroundColor)
            .clipShape(.rect(cornerRadius: 8))
            
            Image(systemName: "xmark")
              .foregroundStyle(Constants.Colors.dropdownMenuBackground)
              .onTapGesture {
                withAnimation {
                  vm.toggleSearch()
                  searchText = ""
                }
              }
          } else {
            if !showEmptyState {
              ViewTypeMenu(selectedViewType: $vm.viewType)
            }
            Spacer()
            if !vm.copiedItems.isEmpty {
              HStack(spacing: 5) {
                Text("Delete all")
                  .font(.body)
                  .foregroundStyle(.accent)
                Image(systemName: "trash")
                  .resizable()
                  .frame(width: 13.5, height: 15)
                  .foregroundStyle(.accent)
              }.onTapGesture {
                withAnimation {
                  vm.clearHistory()
                }
              }
            }
          }
        }
        .onChange(of: searchText) { _ in
          withAnimation {
            vm.searchItems(with: searchText)
          }
        }
        
        ScrollView {
          contentView
        }
      }
      
      if showEmptyState {
        Image(systemName: "teddybear.fill")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundStyle(Constants.Colors.blue)
          .opacity(0.4)
      }
    }
  }
}
