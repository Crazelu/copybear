//
//  HotKeySetupView.swift
//  CopyBear
//
//  Created by LUCKY EBERE on 26/10/2024.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var vm: CopiedItemsViewModel
  @EnvironmentObject var shortcutVm: ShortcutViewModel
  
  @State var showCheckMark = false
  @AppStorage(Constants.Strings.deleteAfterDays) var deleteAfterDays = Constants.Numbers.defaultStalePeriodInDays
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 16) {
        CopyBearLogoHeader(hideAction: true)
        BackButton(title: "Settings") {
          vm.goBackHome()
        }
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            Text("Customize Shortcut")
              .font(.title3)
            ShortcutHStack(hotKey: $shortcutVm.shortcutKey)
            Text("Auto-Delete Items After")
              .font(.title3)
            HStack {
              DeleteAfterInput(days: $deleteAfterDays)
              Text("DAYS")
                .foregroundStyle(Constants.Colors.subtitleTextColor)
            }
            RoundedButton(title: "Update") {
              shortcutVm.registerShortcut {
                showCheckMark.toggle()
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                  showCheckMark.toggle()
                  timer.invalidate()
                }
              }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 4)
          }.opacity(showCheckMark ? 0.2 : 1.0)
        }
      }
      
      if showCheckMark {
        VStack {
          Image(systemName: "checkmark")
            .font(.title)
            .foregroundStyle(Constants.Colors.dropdownMenuBackground)
            .padding([.bottom], 4)
          Text("Settings Updated")
            .font(.body)
            .foregroundStyle(Constants.Colors.dropdownMenuBackground)
        }
      }
    }
  }
}

private struct ShortcutHStack: View {
  let hotKey: Binding<String>
  
  var body: some View {
    HStack {
      Key(key: "CMD")
      Plus()
      Key(key: "SHIFT")
      Plus()
      KeyInput(input: hotKey)
    }
  }
}

private struct Key: View {
  let key: String
  
  var body: some View {
    Text(key)
      .foregroundStyle(Constants.Colors.subtitleTextColor)
      .padding(12)
      .frame(width: 72, height: 56)
      .background(Constants.Colors.keyBackgroundColor)
      .clipShape(.rect(cornerRadius: 10))
    
  }
}

private struct KeyInput: View {
  let input: Binding<String>
  
  @State private var text: String
  
  init(input: Binding<String>) {
    self.input = input
    _text = State(initialValue: input.wrappedValue)
  }
  
  
  var body: some View {
    VStack(spacing: 0) {
      TextField("", text: $text)
        .multilineTextAlignment(.center)
        .padding([.horizontal, .top], 12)
        .padding(.bottom, 8)
        .textFieldStyle(.plain)
        .onChange(of: text) { newValue in
          if newValue.isEmpty {
            text = ""
            input.wrappedValue = ""
          }
          // Allow only single letters (a-z, A-Z)
          else if let lastCharacter = newValue.last, let lastLetter = String(lastCharacter) as String?,
                  lastLetter.range(of: "^[a-zA-Z]$", options: .regularExpression) != nil {
            text = lastLetter.uppercased()
            input.wrappedValue = text
          } else {
            text = input.wrappedValue
          }
        }
      
      Divider()
        .frame(height: 1)
        .background(Constants.Colors.dropdownMenuBackground)
        .padding([.bottom, .horizontal], 12)
    }
    .frame(width: 72, height: 56)
    .background(Constants.Colors.keyBackgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

private struct DeleteAfterInput: View {
  @Binding var days: Int
  @State private var text: String
  
  init(days: Binding<Int>) {
    self._days = days
    self._text = State(initialValue: days.wrappedValue == 0 ? "" : "\(days.wrappedValue)")
  }
  
  var body: some View {
    VStack(spacing: 0) {
      TextField("0", text: $text)
        .multilineTextAlignment(.center)
        .padding([.horizontal, .top], 12)
        .padding(.bottom, 8)
        .textFieldStyle(.plain)
        .onChange(of: text) { newValue in
          if newValue.isEmpty {
            text = ""
            days = Constants.Numbers.defaultStalePeriodInDays
          }
          // Allow only digits that do not start with 0
          else if newValue.range(of: "^[1-9]\\d*$", options: .regularExpression) != nil {
            days = Int(newValue) ?? Constants.Numbers.defaultStalePeriodInDays
          } else {
            text = ""
          }
        }
      Divider()
        .frame(height: 1)
        .background(Constants.Colors.dropdownMenuBackground)
        .padding([.bottom, .horizontal], 12)
    }
    .frame(width: 72, height: 56)
    .background(Constants.Colors.keyBackgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

private struct Plus: View {
  var body: some View {
    Image(systemName: "plus")
      .font(.headline)
      .padding([.horizontal], 16)
  }
}

private struct RoundedButton: View {
  let title: String
  let action: () -> Void
  
  var body: some View {
    Text(title)
      .font(.title3)
      .padding()
      .frame(width: 340)
      .background(.clear)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay {
        RoundedRectangle(cornerRadius: 10)
          .stroke()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation {
          action()
        }
      }
  }
}
