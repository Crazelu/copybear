//
//  Utility.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import Foundation

extension String {
  var fileExtension: String {
    split(separator: ".").last?.lowercased() ?? ""
  }

  var isImage: Bool {
    ["png", "jpg", "webp", "jpeg", "gif", "heic", "avif", "tiff", "ico", "psd", "exr"].contains(self.lowercased())
  }
}

extension Data {
  var content: String {
    String(data: self, encoding: .utf8) ?? ""
  }

  var stripped: String {
    if !content.isEmpty {
      let index = content.index(content.startIndex, offsetBy: 7)
      return String(content[index...])
    }
    return content
  }
}
