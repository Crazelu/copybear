//
//  ViewTypeMenu.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import SwiftUI

struct ViewTypeMenu: View {
  @Binding var selectedViewType: ViewType
  @State var expanded = false

  private var title: String {
    selectedViewType == ViewType.all ? "All" : "Categories"
  }

  private func selectViewType(_ viewType: ViewType) {
    withAnimation {
      selectedViewType = viewType
      expanded.toggle()
    }
  }

  var body: some View {
    VStack {
      if !expanded {
        HStack(spacing: 5) {
          Text(title)
            .font(.title3)
          Image(systemName: "chevron.down")
            .font(.headline)
        }.onTapGesture {
          withAnimation {
            expanded.toggle()
          }
        }
      }

      if expanded {
        VStack(alignment: .leading, spacing: 0) {
          MenuItem(title: "All", selected: selectedViewType == ViewType.all) {
            selectViewType(ViewType.all)
          }
          MenuItem(title: "Categories", selected: selectedViewType == ViewType.categories) {
            selectViewType(ViewType.categories)
          }
        }
        .padding(.top, 0)
      }
    }
  }
}

struct MenuItem: View {
  let title: String
  let selected: Bool
  let onTap: () -> Void

  private var background: Color {
    if selected {
      return Constants.Colors.dropdownMenuBackground.opacity(0.03)
    }
    return .clear
  }

  var body: some View {
    Text(title)
      .font(.title3)
      .padding(10)
      .frame(width: 163, height: 47, alignment: .leading)
      .background(background)
      .clipShape(.rect(cornerRadius: 10))
      .onTapGesture {
        onTap()
      }
  }
}
