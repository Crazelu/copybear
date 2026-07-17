//
//  CopyItemStore.swift
//  CopyBear
//

import Foundation

// Persists clipboard history to Application Support so it survives restarts.
// Each mutation is committed atomically before returning; expired items are
// pruned by CopiedItemsViewModel.deleteExpiredItems after loading.
final class CopyItemStore {
  private struct StoredHistory: Codable {
    let version: Int
    let items: [CopyItem]
  }
  
  private enum StoreError: LocalizedError {
    case unsupportedVersion(Int)
    
    var errorDescription: String? {
      switch self {
      case .unsupportedVersion(let version):
        return "Unsupported clipboard history version: \(version)"
      }
    }
  }
  
  private static let currentVersion = 1
  private let fileURL: URL
  private let queue = DispatchQueue(label: "com.devcrazelu.CopyBear.CopyItemStore", qos: .utility)
  private var canSave = true
  
  init() {
    let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
    ?? FileManager.default.temporaryDirectory
    try? FileManager.default.createDirectory(at: supportDir, withIntermediateDirectories: true)
    fileURL = supportDir.appendingPathComponent("history.plist")
  }
  
  init(fileURL: URL) {
    self.fileURL = fileURL
    try? FileManager.default.createDirectory(
      at: fileURL.deletingLastPathComponent(),
      withIntermediateDirectories: true
    )
  }
  
  func load() -> [CopyItem] {
    guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
    
    do {
      let data = try Data(contentsOf: fileURL)
      let decoder = PropertyListDecoder()
      let history = try decoder.decode(StoredHistory.self, from: data)
      guard history.version == Self.currentVersion else {
        throw StoreError.unsupportedVersion(history.version)
      }
      return history.items
    } catch {
      quarantineInvalidHistory(after: error)
      return []
    }
  }
  
  func save(_ items: [CopyItem]) {
    guard canSave else { return }
    
    queue.sync { [fileURL] in
      let encoder = PropertyListEncoder()
      encoder.outputFormat = .binary
      do {
        let history = StoredHistory(version: Self.currentVersion, items: items)
        let data = try encoder.encode(history)
        try data.write(to: fileURL, options: .atomic)
      } catch {
        NSLog("CopyBear could not save clipboard history: %@", error.localizedDescription)
      }
    }
  }
  
  private func quarantineInvalidHistory(after error: Error) {
    let quarantineURL = fileURL
      .deletingPathExtension()
      .appendingPathExtension("corrupt-\(UUID().uuidString).plist")
    
    do {
      try FileManager.default.moveItem(at: fileURL, to: quarantineURL)
      NSLog(
        "CopyBear quarantined unreadable clipboard history at %@: %@",
        quarantineURL.path,
        error.localizedDescription
      )
    } catch {
      // Never overwrite a file we could not preserve for recovery.
      canSave = false
      NSLog("CopyBear could not quarantine unreadable clipboard history: %@", error.localizedDescription)
    }
  }
}
