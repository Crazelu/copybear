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
  @State var showCheckMark = false

  var showCheckMarkOpacity = 0.2

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
      CopiedLinkView(link: item.data.content, backgroundColor: backgroundColor)
    case .other:
      CopiedFileView(filePath: item.name ?? item.data.content, backgroundColor: backgroundColor)
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
        VStack {
          Image(systemName: "checkmark")
            .font(.title)
            .foregroundStyle(Constants.Colors.dropdownMenuBackground)
            .padding([.bottom], 4)
          Text("Copied")
            .font(.body)
            .foregroundStyle(Constants.Colors.dropdownMenuBackground)
        }
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
      .padding(8)
      .frame(width: 120, height: 100, alignment: .topLeading)
      .background(backgroundColor)
  }
}

private struct CopiedFileView: View {
  var filePath: String
  var backgroundColor: Color

  private var icon: String {
    let fileExtension = filePath.fileExtension
    var icon = "doc"

    switch fileExtension {
    case "mp4", "mov":
      icon = "video"
    case "pdf", "txt", "doc", "docx":
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
    IconTextStack(icon: icon, text: fileName, backgroundColor: backgroundColor)
  }
}

private struct CopiedLinkView: View {
  let link: String
  var backgroundColor: Color

  var body: some View {
    IconTextStack(
      icon: "link",
      text: link.withoutURLPrefixes,
      backgroundColor: backgroundColor
    )
  }
}

private struct IconTextStack: View {
  let icon: String
  let text: String
  var backgroundColor: Color

  var body: some View {
    VStack(alignment: .leading) {
      Image(systemName: icon)
        .font(.footnote)
        .foregroundStyle(Constants.Colors.textColor)
        .padding(10)
        .background(Constants.Colors.textColor.opacity(0.1))
        .clipShape(.circle)
      Text(text)
        .font(.body)
        .foregroundStyle(Constants.Colors.textColor)
        .lineLimit(3)
    }
    .padding(8)
    .frame(width: 120, height: 100, alignment: .leading)
    .background(backgroundColor)
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(Constants.Colors.iconColor.opacity(0.1))
    }
  }
}
