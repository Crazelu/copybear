//
//  ContentView.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 13/10/2024.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel
  @EnvironmentObject var updaterVm: UpdaterViewModel

  var body: some View {
    VStack(spacing: 0) {
      if let version = updaterVm.availableUpdateVersion {
        UpdateBanner(version: version)
      }

      ZStack {
        switch vm.navigationDestination {
        case .home: HomeView()
        case .settings: SettingsView()
        case .category:
          if vm.selectedCategory != nil {
            CategoryContentView(category: .init(get: {
              vm.selectedCategory ?? Category(type: .other)
            }, set: { category in
              vm.selectedCategory = category
            }))
          } else {
            HomeView()
          }
        }
      }
      .padding()
    }
    .frame(width: 430, height: 400)
    .background(Constants.Colors.background)  }
}

private struct UpdateBanner: View {
  let version: String
  @EnvironmentObject var updaterVm: UpdaterViewModel

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: "arrow.down.circle.fill")
      Text("CopyBear v\(version) is available")
        .font(.body)
      Spacer()
      Text("Update")
        .font(.body)
        .fontWeight(.semibold)
        .foregroundStyle(Constants.Colors.iconColor)
        .contentShape(Rectangle())
        .onTapGesture {
          updaterVm.checkForUpdates()
        }
      Image(systemName: "xmark")
        .font(.footnote)
        .foregroundStyle(Constants.Colors.subtitleTextColor)
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation {
            updaterVm.dismissUpdateBanner()
          }
        }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Constants.Colors.keyBackgroundColor)
  }
}
