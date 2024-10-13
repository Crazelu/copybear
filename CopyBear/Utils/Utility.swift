//
//  Utility.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import Foundation
import SwiftUI

extension String {
  var fileExtension: String {
    split(separator: ".").last?.lowercased() ?? ""
  }

  var isImage: Bool {
    ["png", "jpg", "webp", "jpeg", "gif", "heic", "avif", "tiff", "ico", "psd", "exr"].contains(self.lowercased())
  }

  var isURL: Bool {
    let urlRegex = #"^(https?:\/\/)?(www\.)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,6}(\/[^\s]*)?$"#
    let regex = try? NSRegularExpression(pattern: urlRegex, options: .caseInsensitive)
    let range = NSRange(location: 0, length: self.utf16.count)
    return regex?.firstMatch(in: self, options: [], range: range) != nil
  }


  var withoutURLPrefixes: String {
    let regexPattern = #"^(https?:\/\/)?(www\.)?"#
    let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
    let modifiedString = regex?.stringByReplacingMatches(
      in: self,
      options: [],
      range: NSRange(location: 0, length: self.utf16.count),
      withTemplate: ""
    )

    return modifiedString ?? self
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

extension Category {
  var icon: String {
    var resource: String
    switch type {
    case .image: resource = Constants.Icons.imageCategoryIcon
    case .text: resource = Constants.Icons.textCategoryIcon
    case .other: resource = Constants.Icons.otherCategoryIcon
    case .link: resource = Constants.Icons.linkCategoryIcon
    }
    return resource
  }

  var title: String {
    var title: String
    switch type {
    case .image: title = "Photos"
    case .text: title = "Text"
    case .other: title = "Others"
    case .link: title = "Links"
    }
    return title
  }
}

extension Int {
  var color: Color {
    let i = (self + 1) % 6
    return switch i {
    case 1: Constants.Colors.blue
    case 2: Constants.Colors.pink
    case 3: Constants.Colors.purple
    case 4: Constants.Colors.yellow
    case 5: Constants.Colors.green
    default:Constants.Colors.orange
    }
  }
}
