//
//  MenuBarContent.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct MenuBarContentView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel

  @ViewBuilder private var contentView: some View {
    switch vm.viewType {
    case .all:
      AllCopiedItemsView()
    case .categories:
      EmptyView()
    }
  }

  var body: some View {
    ZStack{
      VStack(alignment: .leading, spacing: 20) {
        CopyBearLogoHeader()

        if !vm.allCopies.isEmpty {
          HStack(alignment: .top) {
            ViewTypeMenu(selectedViewType: $vm.viewType)
            Spacer()
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

        ScrollView {
          contentView
        }
      }

      if vm.allCopies.isEmpty {
        Image(systemName: "teddybear.fill")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundStyle(Constants.Colors.blue)
          .opacity(0.4)
      }
    }.padding()
    .frame(width: 430, height: 400)
    .background(Constants.Colors.background)
    .task {
      vm.listenForCopyEvent()
    }
  }
}
