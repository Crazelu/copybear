//
//  CopiedItem.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct CopiedItem: View {
  var text: String

  @State var showCheckMark = false
  @Environment(\.colorScheme) var colorScheme

  private var backgroundColor: Color {
    colorScheme == .dark ?  Color.cyan.opacity(0.3) : Color.indigo.opacity(0.8)
  }

  private var showCheckMarkOpacity: Double {
    colorScheme == .dark ? 0.2 : 0.5
  }

  var body: some View {
    ZStack {
      Text(text)
        .font(.body)
        .foregroundStyle(.white)
        .lineLimit(3)
        .padding()
        .frame(width: 120, height: 100)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 12, height: 12)))
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
