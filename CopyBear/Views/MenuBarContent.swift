//
//  MenuBarContent.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct MenuBarContent: View {
  @StateObject var vm = CopiedItemsViewModel()

  let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible())]

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
    ZStack{
      VStack(alignment: .leading, spacing: 20) {
        CopyBearLogoHeader()

        if !vm.copiedTexts.isEmpty {
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
          LazyVGrid(columns: columns) {
            ForEach(0..<vm.copiedTexts.count, id: \.self) { index in
              CopiedItem(
                text: vm.copiedTexts[index],
                backgroundColor: getCardColor(for: index)
              )
            }
          }
        }
      }

      if vm.copiedTexts.isEmpty {
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
