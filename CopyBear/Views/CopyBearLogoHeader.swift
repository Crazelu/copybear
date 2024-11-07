//
//  CopyBearLogoHeader.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 12/10/2024.
//

import SwiftUI

struct CopyBearLogoHeader: View {
  let showAction: Bool
  @EnvironmentObject var vm: CopiedItemsViewModel

    init() {
      self.showAction = true
    }

    init(hideAction: Bool) {
      self.showAction = !hideAction
    }

  var body: some View {
    HStack {
      Image(Constants.Icons.logo)
        .resizable()
        .scaledToFit()
        .frame(width: 114, height: 30)
      Spacer()

      if showAction {
        Button(action: {
          withAnimation {
            vm.openSettings()
          }
        }) {
          Image(Constants.Icons.settingsIcon)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
      }
    }
  }
}
