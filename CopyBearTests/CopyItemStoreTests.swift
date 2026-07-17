//
//  CopyItemStoreTests.swift
//  CopyBearTests
//

import Foundation
import Testing
@testable import CopyBear

struct CopyItemStoreTests {
  @Test func savesAndLoadsVersionedHistory() throws {
    let directory = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: directory) }
    let fileURL = directory.appendingPathComponent("history.plist")
    let store = CopyItemStore(fileURL: fileURL)
    let expected = [CopyItem(type: .text, data: Data("hello".utf8))]

    store.save(expected)

    #expect(CopyItemStore(fileURL: fileURL).load() == expected)
  }

  @Test func quarantinesInvalidHistoryBeforeStartingFresh() throws {
    let directory = temporaryDirectory()
    defer { try? FileManager.default.removeItem(at: directory) }
    let fileURL = directory.appendingPathComponent("history.plist")
    let invalidData = Data("not a property list".utf8)
    let store = CopyItemStore(fileURL: fileURL)
    try invalidData.write(to: fileURL)

    #expect(store.load().isEmpty)

    let quarantinedFiles = try FileManager.default.contentsOfDirectory(
      at: directory,
      includingPropertiesForKeys: nil
    ).filter { $0.lastPathComponent.hasPrefix("history.corrupt-") }
    #expect(quarantinedFiles.count == 1)
    #expect(try Data(contentsOf: quarantinedFiles[0]) == invalidData)

    let replacement = [CopyItem(type: .text, data: Data("new".utf8))]
    store.save(replacement)
    #expect(CopyItemStore(fileURL: fileURL).load() == replacement)
  }

  private func temporaryDirectory() -> URL {
    FileManager.default.temporaryDirectory
      .appendingPathComponent("CopyItemStoreTests-\(UUID().uuidString)", isDirectory: true)
  }
}
