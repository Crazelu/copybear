//
//  UtilityTests.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import Testing
@testable import CopyBear

struct UtilityTests {

    @Test func testFileExtension() {
      #expect("invalid".fileExtension == "invalid")
      #expect("image.png".fileExtension == "png")
      #expect("//user/downloads/document.pdf".fileExtension == "pdf")
    }

  @Test func testIsImage() {
      #expect("invalid".isImage == false)
      #expect("mp4".isImage == false)
      #expect("png".isImage == true)
      #expect("jpeg".isImage == true)
      #expect("JPG".isImage == true)
      #expect("gif".isImage == true)
      #expect("webp".isImage == true)
      #expect("tiff".isImage == true)
      #expect("avif".isImage == true)
      #expect("ico".isImage == true)
      #expect("psd".isImage == true)
      #expect("exr".isImage == true)
    }

  @Test func testIsURL() {
      #expect("invalid".isURL == false)
      #expect("example.com".isURL == true)
      #expect("www.example.com".isURL == true)
      #expect("https://www.example.com".isURL == true)
      #expect("https://example.com".isURL == true)
      #expect("http://example.com".isURL == true)
    }

  @Test func testWithoutURLPrefixes() {
      #expect("invalid".withoutURLPrefixes == "invalid")
      #expect("www.example.com".withoutURLPrefixes == "example.com")
      #expect("https://www.example.com".withoutURLPrefixes == "example.com")
      #expect("https://example.com".withoutURLPrefixes == "example.com")
      #expect("http://example.com".withoutURLPrefixes == "example.com")
    }
}
