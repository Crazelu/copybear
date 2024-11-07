//
//  HotKeysViewModel.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 26/10/2024.
//

import SwiftUI
import Carbon

class ShortcutViewModel: ObservableObject {
  private let defaults = UserDefaults.standard
  private let hotKey = "CopyBearHotKey"
  private var appDelegate: AppDelegate?

  @Published var shortcutKey: String = "B"

  private var keyCommand: EventHotKeyRef?
  private var eventHandlerRef: EventHandlerRef?

  private var keysTable: [String: Int] = [
    "A": kVK_ANSI_A,
    "B": kVK_ANSI_B,
    "C": kVK_ANSI_C,
    "D": kVK_ANSI_D,
    "E": kVK_ANSI_E,
    "F": kVK_ANSI_F,
    "G": kVK_ANSI_G,
    "H": kVK_ANSI_H,
    "I": kVK_ANSI_I,
    "J": kVK_ANSI_J,
    "K": kVK_ANSI_K,
    "L": kVK_ANSI_L,
    "M": kVK_ANSI_M,
    "N": kVK_ANSI_N,
    "O": kVK_ANSI_O,
    "P": kVK_ANSI_P,
    "Q": kVK_ANSI_Q,
    "R": kVK_ANSI_R,
    "S": kVK_ANSI_S,
    "T": kVK_ANSI_T,
    "U": kVK_ANSI_U,
    "V": kVK_ANSI_V,
    "W": kVK_ANSI_W,
    "X": kVK_ANSI_X,
    "Y": kVK_ANSI_Y,
    "Z": kVK_ANSI_Z
  ]

  func setAppDelegate(_ appDelegate: AppDelegate) {
    self.appDelegate = appDelegate
    shortcutKey = getHotKey()
    registerShortcut()
  }

  private func getHotKey() -> String {
    if let hotKey = defaults.string(forKey: hotKey) {
      return hotKey
    }
    return "B"
  }

  func registerShortcut(onRegistered: () -> Void = {}) {
    if shortcutKey.isEmpty { return }

    unregisterHotKeys()

    if let keyCode = keysTable[shortcutKey] {
      registerKeyCode(keyCode: UInt32(keyCode))
      defaults.set(shortcutKey, forKey: hotKey)
      onRegistered()
    }
  }

  private func registerKeyCode(keyCode: UInt32) {
    var hotKeyID = EventHotKeyID()
    hotKeyID.signature = OSType(0x1234)
    hotKeyID.id = UInt32(1)

    let modifierFlags: UInt32 = UInt32(cmdKey | shiftKey)

    RegisterEventHotKey(keyCode, modifierFlags, hotKeyID, GetApplicationEventTarget(), 0, &keyCommand)

    var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))

    InstallEventHandler(GetApplicationEventTarget(), ShortcutViewModel.hotKeysHandler, 1, &eventSpec, UnsafeMutableRawPointer(Unmanaged.passUnretained(appDelegate!).toOpaque()), &eventHandlerRef)
  }

  private func unregisterHotKeys() {
    if let keyCommand, let eventHandlerRef {
      UnregisterEventHotKey(keyCommand)
      RemoveEventHandler(eventHandlerRef)
    }
  }

  static let hotKeysHandler: EventHandlerUPP = { (nextHandler, theEvent, userData) -> OSStatus in
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
