//
//  CopiedItemViewModel.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

class CopiedItemsViewModel: ObservableObject {
  let pasteBoard = NSPasteboard.general

  @Published var navigationDestination: NavigationDestination = NavigationDestination.home
  @Published var selectedCategory: Category?

  @Published var viewType: ViewType = ViewType.all

  // Whether to care about a copy event.
  // This will be set to true when a copy action is initiated by the app
  // which will be for an item already in history. So we won't need to add another entry.
  private var doNotHonorCopy = false

  private var changeCount: Int = -1

  @Published var copiedItems: [CopyItem] = []
  @Published var categories: [Category] = [
    Category(type: .text),
    Category(type: .image),
    Category(type: .other)
  ]

  private func getLastCopiedItem() {
    if let image = pasteBoard.data(forType: .png) {
      let item = CopyItem(type: .image, data: image)
      if copiedItems.contains(where: {$0 == item}) {return}
      copiedItems.append(item)
      if let category = categories.first(where: { $0.type == CopyItemType.image }) {
        category.addItem(item)
        return
      }
    }

    if let file = pasteBoard.data(forType: .fileURL) {
      let item = CopyItem(type: .other, data: file)
      if copiedItems.contains(where: {$0 == item || $0.fileUrl == file }) {return}
      copiedItems.append(item)

      // check if file is an image
      if item.data.content.fileExtension.isImage {
        do {
          let imageData = try Data(contentsOf: URL(filePath: file.stripped))
          if let category = categories.first(where: { $0.type == CopyItemType.image }) {
            let imageItem = CopyItem(type: .image, data: imageData, fileUrl: file)
            if copiedItems.contains(where: {$0 == imageItem}) {return}
            category.addItem(imageItem)
            copiedItems.removeAll(where: {$0 == item})
            copiedItems.append(imageItem)
            return
          }
        } catch {
          print(error.localizedDescription)
        }
      }

      if let category = categories.first(where: { $0.type == CopyItemType.other }) {
        category.addItem(item)
        return
      }
    }

    if let text = pasteBoard.data(forType: .string) {
      let item = CopyItem(type: .text, data: text)
      if copiedItems.contains(where: {$0 == item}) {return}
      copiedItems.append(item)
      if let category = categories.first(where: { $0.type == CopyItemType.text }) {
        category.addItem(item)
      }
    }
  }


  func listenForCopyEvent() {
    if doNotHonorCopy {
      doNotHonorCopy.toggle()
      return
    }

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
    copiedItems = []
    categories = [
      Category(type: .text),
      Category(type: .image),
      Category(type: .other)
    ]
  }

  func clearCategoryHistory(for itemType: CopyItemType) {
    copiedItems.removeAll(where: {$0.type == itemType})

    if let category = categories.first(where: {$0.type == itemType}) {
      category.items = []
    }
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

  func selectCategory(_ category: Category) {
    selectedCategory = category
    navigationDestination = NavigationDestination.category
  }

  func goBackHome() {
    doNotHonorCopy = true
    navigationDestination = NavigationDestination.home
    selectedCategory = nil
  }
}
