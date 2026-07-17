//
//  UpdaterViewModel.swift
//  CopyBear
//

import SwiftUI
import Combine
import Sparkle

// Swallows updater error alerts (e.g. unreachable/missing appcast) instead of
// showing Sparkle's modal; update checks fail silently and retry on schedule
private final class SilentErrorUserDriver: SPUStandardUserDriver {
  override func showUpdaterError(_ error: Error, acknowledgement: @escaping () -> Void) {
    NSLog("CopyBear updater error: \(error.localizedDescription)")
    acknowledgement()
  }
}

final class UpdaterViewModel: NSObject, ObservableObject {
  // Set when a scheduled background check finds an update, drives the in-app banner
  @Published var availableUpdateVersion: String?

  private var updater: SPUUpdater?

  override init() {
    super.init()
    let driver = SilentErrorUserDriver(hostBundle: .main, delegate: self)
    let updater = SPUUpdater(
      hostBundle: .main,
      applicationBundle: .main,
      userDriver: driver,
      delegate: nil
    )
    do {
      try updater.start()
      // Update checks are always on
      updater.automaticallyChecksForUpdates = true
      self.updater = updater
    } catch {
      NSLog("CopyBear updater failed to start: \(error.localizedDescription)")
    }
  }

  func checkForUpdates() {
    availableUpdateVersion = nil
    updater?.checkForUpdates()
  }

  func dismissUpdateBanner() {
    availableUpdateVersion = nil
  }
}

extension UpdaterViewModel: SPUStandardUserDriverDelegate {
  var supportsGentleScheduledUpdateReminders: Bool { true }

  func standardUserDriverShouldHandleShowingScheduledUpdate(_ update: SUAppcastItem, andInImmediateFocus immediateFocus: Bool) -> Bool {
    // Defer scheduled update alerts to the in-app banner;
    // user-initiated checks still get Sparkle's standard UI
    false
  }

  func standardUserDriverWillHandleShowingUpdate(_ handleShowingUpdate: Bool, forUpdate update: SUAppcastItem, state: SPUUserUpdateState) {
    if !handleShowingUpdate {
      availableUpdateVersion = update.displayVersionString
    }
  }

  func standardUserDriverWillFinishUpdateSession() {
    availableUpdateVersion = nil
  }
}
