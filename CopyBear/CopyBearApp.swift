//
//  CopyBearApp.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI
import ServiceManagement

@main
struct CopyBearApp: App {
  let vm = CopiedItemsViewModel()

  init() {
    vm.listenForCopyEvent()
    try? SMAppService.mainApp.register()
  }

  var body: some Scene {
    MenuBarExtra("CopyBear", systemImage: "teddybear.fill") {
      ContentView().environmentObject(vm)
    }.menuBarExtraStyle(.window)

    WindowGroup {}
  }
}
