//
//  BackButton.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 04/11/2024.
//

import SwiftUI

struct BackButton: View {
  let title: String
  let onTap: () -> Void

  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: "chevron.left")
        .font(.body)
      Text(title)
        .font(.title3)
        .fontWeight(.medium)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation {
        onTap()
      }
    }
  }
}
