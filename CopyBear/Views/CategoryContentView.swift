//
//  CategoryContentView.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import SwiftUI

struct CategoryContentView: View {
  @Binding var category: Category
  @EnvironmentObject var vm: CopiedItemsViewModel

  let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible())
  ]

  var body: some View {
    ZStack{
      VStack(alignment: .leading, spacing: 20) {
        CopyBearLogoHeader()

          HStack(alignment: .top) {
            HStack(spacing: 5) {
              Image(systemName: "chevron.left")
                .font(.headline)
              Text(category.title)
                .font(.title2)
                .fontWeight(.medium)
            }
            .onTapGesture {
              withAnimation {
                vm.goBackHome()
              }
            }

            Spacer()

            if !category.items.isEmpty {
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
                  vm.clearCategoryHistory(for: category.type)
                }
              }
            }
          }

        ScrollView {
          LazyVGrid(columns: columns) {
            ForEach(0..<category.items.count, id: \.self) { index in
              CopyItemView(
                item: category.items[index],
                backgroundColor: index.color
              )
            }
          }
        }
      }

      if category.items.isEmpty {
        Image(systemName: "teddybear.fill")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundStyle(Constants.Colors.blue)
          .opacity(0.4)
      }
    }.padding()
    .frame(width: 430, height: 400)
    .background(Constants.Colors.background)
  }
}
