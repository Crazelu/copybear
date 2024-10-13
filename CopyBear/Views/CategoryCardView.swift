//
//  CategoryCardView.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import SwiftUI

struct CategoryCardView: View {
  @Binding var category: Category

  var subtitle: String {
    let itemCount = category.items.count
    var subtitle: String

    switch category.type {
    case .text: subtitle = itemCount == 1 ? "Copy" : "Copies"
      case .other: subtitle = itemCount == 1 ? "File" : "Files"
      case .image: subtitle = itemCount == 1 ? "Photo" : "Photos"
      case .link: subtitle = itemCount == 1 ? "Link" : "Links"
    }
    return "\(itemCount) \(subtitle)"
  }

  var body: some View {
    VStack(alignment: .leading) {
      Image(category.icon)
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundStyle(Constants.Colors.iconColor)
        .padding(14)
        .background(Constants.Colors.iconColor.opacity(0.1))
        .clipShape(.circle)
        .padding(.bottom, 18)

      Text(category.title)
        .font(.title3)
        .fontWeight(.semibold)
        .padding(.bottom, 10)

      Text(subtitle)
        .font(.title3)
        .foregroundStyle(Constants.Colors.subtitleTextColor)
    }
    .frame(width: 120, height: 172)
    .background(Constants.Colors.cardColor)
    .clipShape(.rect(cornerRadius: 10))
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(Constants.Colors.iconColor.opacity(0.1))
    }
  }
}
