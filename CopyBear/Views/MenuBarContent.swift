//
//  MenuBarContent.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct MenuBarContent: View {
  @StateObject var vm = CopiedItemsViewModel()

  let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    ZStack{
      VStack(alignment: .leading){
        HStack {
          Text("CopyBear")
            .font(.title2)
            .padding([.bottom], 10)
          Spacer()
          if !vm.copiedTexts.isEmpty {
            Image(systemName: "trash")
              .foregroundStyle(.red)
              .onTapGesture {
                withAnimation {
                  vm.clearHistory()
                }
              }
          }
        }

        ScrollView {
          LazyVGrid(columns: columns) {
            ForEach(0..<vm.copiedTexts.count, id: \.self) { index in
              CopiedItem(text: vm.copiedTexts[index])
            }
          }
        }
        Spacer()
      }

      if vm.copiedTexts.isEmpty {
        Image(systemName: "teddybear.fill")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundStyle(.cyan)
          .opacity(0.4)
      }
    }.padding()
    .frame(width: 400, height: 400)
    .task {
      vm.listenForCopyEvent()
    }
  }
}
