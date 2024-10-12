//
//  CopiedItem.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct CopiedItem: View {
  var text: String
  var backgroundColor: Color

  @Environment(\.colorScheme) var colorScheme
  @State var showCheckMark = false

  private var showCheckMarkOpacity: Double {
    colorScheme == .dark ? 0.2 : 0.5
  }

  var body: some View {
    ZStack {
      Text(text)
        .font(.body)
        .foregroundStyle(Constants.Colors.textColor)
        .lineLimit(5)
        .padding(10)
        .frame(width: 120, height: 100, alignment: .topLeading)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture {
          let pasteboard =  NSPasteboard.general
          pasteboard.clearContents()
          pasteboard.setString(text, forType: .string)
          withAnimation {
            showCheckMark.toggle()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
              showCheckMark.toggle()
              timer.invalidate()
            }
          }
        }.opacity(showCheckMark ? showCheckMarkOpacity : 1.0)

      if showCheckMark {
        Image(systemName: "checkmark")
          .font(.title)
          .foregroundStyle(.white)
      }
    }
  }
}
