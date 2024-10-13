//
//  CopiedItemViewModel.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

class CopiedItemsViewModel: ObservableObject {
  let pasteBoard = NSPasteboard.general

  @Published var viewType: ViewType = ViewType.all

  // Whether to care about a copy event.
  // This will be set to true when a copy action is initiated by the app
  // which will be for an item already in history. So we won't need to add another entry.
  private var doNotHonorCopy = false

  private var changeCount: Int = -1

  @Published var allCopies: [CopyItem] = []
  @Published var categories: [Category] = [
    Category(type: .text, items: []),
    Category(type: .image, items: []),
    Category(type: .other, items: [])
  ]

  private func getLastCopiedItem() {
    if let image = pasteBoard.data(forType: .png) {
      let item = CopyItem(type: .image, data: image)
      if allCopies.contains(where: {$0 == item}) {return}
      allCopies.append(item)
      if var category = categories.first(where: { $0.type == CopyItemType.image }) {
        category.addItem(image)
        return
      }
    }

    if let file = pasteBoard.data(forType: .fileURL) {
      let item = CopyItem(type: .other, data: file)
      if allCopies.contains(where: {$0 == item || $0.fileUrl == file }) {return}
      allCopies.append(item)

      // check if file is an image
      if item.data.content.fileExtension.isImage {
        do {
          let imageData = try Data(contentsOf: URL(filePath: file.stripped))
          if var category = categories.first(where: { $0.type == CopyItemType.image }) {
            let imageItem = CopyItem(type: .image, data: imageData, fileUrl: file)
            if allCopies.contains(where: {$0 == imageItem}) {return}
            category.addItem(imageData)
            allCopies.removeAll(where: {$0 == item})
            allCopies.append(imageItem)
            return
          }
        } catch {
          print(error.localizedDescription)
        }
      }

      if var category = categories.first(where: { $0.type == CopyItemType.other }) {
        category.addItem(file)
        return
      }
    }

    if let text = pasteBoard.data(forType: .string) {
      let item = CopyItem(type: .text, data: text)
      if allCopies.contains(where: {$0 == item}) {return}
      allCopies.append(item)
      if var category = categories.first(where: { $0.type == CopyItemType.text }) {
        category.addItem(text)
      }
    }
  }


    func listenForCopyEvent() {
      changeCount = pasteBoard.changeCount
      getLastCopiedItem()

      Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        let newChangeCount = self.pasteBoard.changeCount
        if newChangeCount > self.changeCount && !self.doNotHonorCopy {
          self.changeCount = newChangeCount
          self.getLastCopiedItem()
        }

        self.doNotHonorCopy = false
      }
    }

    func clearHistory() {
      allCopies = []
      categories = [
        Category(type: .text, items: []),
        Category(type: .image, items: []),
        Category(type: .other, items: [])
      ]
    }

    func paste(_ item: CopyItem) {
      pasteBoard.clearContents()
      var pasteBoardType: NSPasteboard.PasteboardType

      switch item.type {
        case .text:
          pasteBoardType = .string
        case .image:
          pasteBoardType = .png
        case .other:
          pasteBoardType = .fileURL
      }

      doNotHonorCopy = true
      if item.type == .image && item.fileUrl != nil {
        pasteBoard.setData(item.fileUrl!, forType: .fileURL)
      } else {
        pasteBoard.setData(item.data, forType: pasteBoardType)
      }
    }
}
