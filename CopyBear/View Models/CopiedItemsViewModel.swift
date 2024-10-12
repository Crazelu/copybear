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

  @Published var copiedTexts: [String] = []
  var changeCount: Int = -1

  private func getCopiedText() {
    if let text = pasteBoard.string(forType: .string) {
      if !copiedTexts.contains(text) {
        copiedTexts.append(text)
      }
    }
  }

  func listenForCopyEvent() {
    changeCount = pasteBoard.changeCount
    getCopiedText()

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      let newChangeCount = self.pasteBoard.changeCount
      if newChangeCount > self.changeCount {
        self.changeCount = newChangeCount
        self.getCopiedText()
      }
    }
  }

  func clearHistory() {
    copiedTexts = []
  }
}
