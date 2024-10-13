//
//  CopiedItem.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

struct CopyItemView: View {
  var item: CopyItem
  var backgroundColor: Color

  @EnvironmentObject var vm: CopiedItemsViewModel
  @Environment(\.colorScheme) var colorScheme
  @State var showCheckMark = false

  private var showCheckMarkOpacity: Double {
    colorScheme == .dark ? 0.2 : 0.5
  }

  @ViewBuilder private var copiedItemView: some View {
    switch item.type {
    case .text:
      CopiedTextView(
        text: item.data.content,
        backgroundColor: backgroundColor
      )
    case .image:
      Image(nsImage: NSImage(data: item.data)!)
        .resizable()
        .scaledToFit()
        .frame(width: 120, height: 100)
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Constants.Colors.iconColor.opacity(0.1))
        }
    case .link:
      CopiedLinkView(link: item.data.content)
    case .other:
      CopiedFileView(filePath: item.data.content)
    }
  }

  var body: some View {
    ZStack {
      copiedItemView
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture {
          vm.paste(item)
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


private struct CopiedTextView: View {
  var text: String
  var backgroundColor: Color

  var body: some View {
    Text(text)
      .font(.body)
      .foregroundStyle(Constants.Colors.textColor)
      .lineLimit(5)
      .padding(10)
      .frame(width: 120, height: 100, alignment: .topLeading)
      .background(backgroundColor)
  }
}

private struct CopiedFileView: View {
  var filePath: String

  private var icon: String {
    let fileExtension = filePath.fileExtension
    var icon = "doc"

    switch fileExtension {
    case "mp4", "mov":
      icon = "video"
    case "pdf", "txt":
      icon = "doc.text"
    case "mp3", "wav":
      icon = "music.note"
    default: icon = "doc"
    }

    return icon
  }

  private var fileName: String {
    filePath.split(separator: "/").last?.lowercased() ?? ""
  }

  var body: some View {
    IconTextStack(icon: icon, text: fileName)
  }
}

private struct CopiedLinkView: View {
  let link: String

  var body: some View {
    IconTextStack(icon: "link", text: link.withoutURLPrefixes)
  }
}

private struct IconTextStack: View {
  let icon: String
  let text: String

  var body: some View {
    VStack(alignment: .center) {
      Image(systemName: icon)
        .font(.footnote)
        .foregroundStyle(Constants.Colors.iconColor)
        .padding(14)
        .background(Constants.Colors.iconColor.opacity(0.1))
        .clipShape(.circle)
      Text(text)
        .font(.body)
        .lineLimit(2)
    }
    .padding(10)
    .frame(width: 120, height: 100)
    .background(Constants.Colors.cardColor)
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(Constants.Colors.iconColor.opacity(0.1))
    }
  }
}
