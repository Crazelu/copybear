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
  let defaults = UserDefaults.standard
  let versionKey = "CopyBearVersion"

  func applicationDidFinishLaunching(_ notification: Notification) {
    try? SMAppService.mainApp.register()
    checkInstalledVersionAndUpdateLoginItem()
    vm.listenForCopyEvent()
    setupMenuBar()
    registerHotKey()
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
    popover.contentViewController?.view = NSHostingView(rootView:ContentView().environmentObject(vm))
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

  private func registerHotKey() {
    var hotKeyID = EventHotKeyID()
    hotKeyID.signature = OSType(0x1234)
    hotKeyID.id = UInt32(1)

    let modifierFlags: UInt32 = UInt32(cmdKey | shiftKey)
    let keyCode: UInt32 = 9 // 'V' key

    RegisterEventHotKey(keyCode, modifierFlags, hotKeyID, GetApplicationEventTarget(), 0, &keyCommand)

    var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

    InstallEventHandler(GetApplicationEventTarget(), AppDelegate.hotKeyHandler, 1, &eventSpec, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), nil)
  }

  static let hotKeyHandler: EventHandlerUPP = { (nextHandler, theEvent, userData) -> OSStatus in
    var hotKeyID = EventHotKeyID()
    GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)

    if hotKeyID.id == 1 {
      let appDelegate = Unmanaged<AppDelegate>.fromOpaque(userData!).takeUnretainedValue()
      DispatchQueue.main.async {
        appDelegate.togglePopover()
      }
    }

    return noErr
  }
}
