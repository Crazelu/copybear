//
//  CopyBearApp.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 07/10/2024.
//

import SwiftUI
import ServiceManagement
import Carbon

@main
struct CopyBearApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    Settings {}
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusItem: NSStatusItem!
  var popover: NSPopover!
  var keyCommand: EventHotKeyRef?
  let vm = CopiedItemsViewModel()
  let shortcutViewModel = ShortcutViewModel()
  let defaults = UserDefaults.standard
  let versionKey = "CopyBearVersion"

  func applicationDidFinishLaunching(_ notification: Notification) {
    shortcutViewModel.setAppDelegate(self)
    try? SMAppService.mainApp.register()
    checkInstalledVersionAndUpdateLoginItem()
    vm.listenForCopyEvent()
    setupMenuBar()
  }

  // Updates login item when an updated version of the app is opened
  private func checkInstalledVersionAndUpdateLoginItem() {
    if let version = getAppVersion() {
      guard let installedVersion = defaults.string(forKey: versionKey)
      else {
        defaults.set(version, forKey: versionKey)
        return
      }

      let currentVersion = Double(version) ?? 0
      let persistedVersion = Double(installedVersion) ?? 0

      if currentVersion > persistedVersion {
        SMAppService.mainApp.unregister(completionHandler: { error in
          if error == nil {
            self.defaults.set(version, forKey: self.versionKey)
            try? SMAppService.mainApp.register()
          }
        })
      }
    }
  }

  private func setupMenuBar() {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusItem.button?.image = NSImage(systemSymbolName: "teddybear.fill", accessibilityDescription: "CopyBear")
    statusItem.button?.action = #selector(handleStatusItemClick)

    popover = NSPopover()
    popover.behavior = .transient
    popover.contentViewController = NSViewController()
    popover.contentViewController?.view = NSHostingView(rootView: ContentView().environmentObject(vm).environmentObject(shortcutViewModel))
  }

  @objc func togglePopover() {
    if let button = statusItem.button {
      if popover.isShown {
        popover.performClose(nil)
      } else {
        vm.goBackHomeAndShowAll()
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
      }
    }
  }

  @objc func quitApp() {
    NSApplication.shared.terminate(self)
  }

  @objc func handleStatusItemClick(_ sender: Any?) {
    if let event = NSApp.currentEvent {
      if event.type == .rightMouseUp || event.modifierFlags.contains(.control) {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        if let version = getAppVersion() {
          menu.addItem(NSMenuItem.separator())
          menu.addItem(NSMenuItem(title: "v\(version)", action: nil, keyEquivalent: ""))
        }
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
      } else {
        togglePopover()
      }
    }
  }

  private func getAppVersion() -> String? {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }
}
