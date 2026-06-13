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
    Category(type: .link),
    Category(type: .image),
    Category(type: .other)
  ]
  @Published var isSearching: Bool = false
  @Published var searchResults: [CopyItem] = []

  private var searchQuery = ""

  private func addCopyItem(_ item: CopyItem) {
    copiedItems.insert(item, at: 0)
    if isSearching {
      searchItems(with: searchQuery)
    }
  }

  private func getLastCopiedItem() {
    if doNotHonorCopy {
      doNotHonorCopy.toggle()
      return
    }

    if let image = pasteBoard.data(forType: .png), let fileName = pasteBoard.data(forType: .string)  {
      let item = CopyItem(type: .image, data: image, name: fileName.content)
      if copiedItems.contains(where: {$0 == item}) { moveItemToFront(item); return }
      addCopyItem(item)
      if let category = categories.first(where: { $0.type == CopyItemType.image }) {
        category.addItem(item)
        return
      }
    }

    if let file = pasteBoard.data(forType: .fileURL), let fileName = pasteBoard.data(forType: .string) {
      let item = CopyItem(type: .other, data: file, name: fileName.content)
      if let existingItem = copiedItems.first(where: {$0 == item || $0.fileUrl == file }) { moveItemToFront(existingItem); return }


      // check if file is an image
      if fileName.content.fileExtension.isImage {
        do {
          let imageData = try Data(contentsOf: URL(filePath: file.stripped))
          if let category = categories.first(where: { $0.type == CopyItemType.image }) {
            let imageItem = CopyItem(type: .image, data: imageData, fileUrl: file, name: fileName.content)
            if copiedItems.contains(where: {$0 == imageItem}) { moveItemToFront(imageItem); return }
            category.addItem(imageItem)
            addCopyItem(imageItem)
            return
          }
        } catch {
          print(error.localizedDescription)
        }
      }

      addCopyItem(item)
      if let category = categories.first(where: { $0.type == CopyItemType.other }) {
        category.addItem(item)
        return
      }
    }

    if let text = pasteBoard.data(forType: .string) {
      let itemType: CopyItemType = text.content.isURL ? .link : .text
      let item = CopyItem(type: itemType, data: text)
      if copiedItems.contains(where: {$0 == item}) { moveItemToFront(item); return }
      addCopyItem(item)
      if let category = categories.first(where: {$0.type == itemType}) {
        category.addItem(item)
      }
    }
  }

  private func moveItemToFront(_ item: CopyItem) {
    if let existingIndex = copiedItems.firstIndex(where: {$0 == item}) {
      let existingItem = copiedItems.remove(at: existingIndex)
      copiedItems.insert(existingItem, at: 0)
    }

    if let category = categories.first(where: {$0.type == item.type}),
       let categoryIndex = category.items.firstIndex(where: {$0 == item}) {
      let existingItem = category.items.remove(at: categoryIndex)
      category.items.insert(existingItem, at: 0)
    }
  }

  private func sortCategories() {
    categories.sort { a, b in
      a.items.count > b.items.count
    }
  }

  func toggleSearch() {
    isSearching.toggle()
    searchItems(with: "")
    selectedCategory = nil
  }

  func searchItems(with query: String) {
    searchQuery = query
    if query.isEmpty {
      searchResults = copiedItems
      return
    }
    searchResults = copiedItems.filter { item in
      switch item.type {
      case .text, .link:
        return item.data.content.localizedCaseInsensitiveContains(query)
      case .other, .image:
        return item.name?.localizedCaseInsensitiveContains(query) ?? false      }
    }
  }

  func listenForCopyEvent() {
    changeCount = pasteBoard.changeCount
    getLastCopiedItem()
    sortCategories()

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      let newChangeCount = self.pasteBoard.changeCount
      if newChangeCount > self.changeCount {
        self.changeCount = newChangeCount
        self.getLastCopiedItem()
        self.sortCategories()
      }
    }
  }

  func clearHistory() {
    copiedItems = []
    categories = [
      Category(type: .text),
      Category(type: .link),
      Category(type: .image),
      Category(type: .other)
    ]
    isSearching = false
  }

  func clearCategoryHistory(for itemType: CopyItemType) {
    copiedItems.removeAll(where: {$0.type == itemType})

    if let category = categories.first(where: {$0.type == itemType}) {
      category.items = []
    }
    sortCategories()
  }

  func paste(_ item: CopyItem) {
    pasteBoard.clearContents()
    var pasteBoardType: NSPasteboard.PasteboardType

    switch item.type {
    case .text, .link:
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

  func deleteItem(_ item: CopyItem) {
    copiedItems.removeAll(where: {$0 == item})
    searchResults.removeAll(where: {$0 == item})

    if let category = categories.first(where: {$0.items.contains(item)}) {
      category.items.removeAll(where: {$0 == item})
    }
    sortCategories()
    if copiedItems.isEmpty {
      isSearching = false
    }
  }

  func goBackHome() {
    navigationDestination = NavigationDestination.home
    selectedCategory = nil
  }

  func goBackHomeAndShowAll() {
    goBackHome()
    viewType = .all
  }

  func openSettings() {
    navigationDestination = NavigationDestination.settings
  }
}
