//
//  CopyBearApp.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI

@main
struct CopyBearApp: App {
    var body: some Scene {
      MenuBarExtra("CopyBear", systemImage: "teddybear.fill") {
        MenuBarContentView().environmentObject(CopiedItemsViewModel())
          }.menuBarExtraStyle(.window)

        WindowGroup {

        }
    }
}
