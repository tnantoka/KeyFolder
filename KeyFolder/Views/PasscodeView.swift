//
//  PasscodeView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

struct PasscodeView: View {
  enum Mode {
    case unlock, change, initial
  }

  let mode: Mode

  @Binding var isLocked: Bool
  @State private var isPortrait = UIDevice.current.orientation.isPortrait
  @State private var passcode = ""
  @State private var hasError = false
  @State private var isMask = true
  @State private var isSaving = false

  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        let isPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        let buttonSize =
          isPhone
          ? (isPortrait ? geometry.size.width * 0.18 : geometry.size.height * 0.14)
          : (isPortrait ? geometry.size.width * 0.14 : geometry.size.height * 0.14)
        let padding =
          isPhone
          ? geometry.size.width * (isPortrait ? 0.2 : 0.38)
          : geometry.size.width * (isPortrait ? 0.28 : 0.36)
        VStack {
          ZStack(alignment: .trailing) {
            if isMask {
              SecureField(NSLocalizedString("Passcode", comment: ""), text: $passcode)
                .textFieldStyle(.roundedBorder)
                .font(isPhone ? .title2 : .largeTitle)
                .disabled(true)
                .foregroundColor(hasError ? .red : Color("KeypadButtonColor"))
                .frame(minWidth: 200)
                .frame(height: 44)
            } else {
              TextField(NSLocalizedString("Passcode", comment: ""), text: $passcode)
                .textFieldStyle(.roundedBorder)
                .font(isPhone ? .title2 : .largeTitle)
                .disabled(true)
                .foregroundColor(hasError ? .red : Color("KeypadButtonColor"))
                .frame(minWidth: 200)
                .frame(height: 44)
            }
            Button(
              action: { isMask.toggle() },
              label: {
                Image(systemName: isMask ? "eye" : "eye.slash")
              }
            )
            .buttonStyle(.plain)
            .padding(.trailing, 8)
          }
          .padding(.bottom, 16)
          KeypadView(
            text: $passcode,
            buttonSize: buttonSize,
            onChange: {
              hasError = false
            },
            onSubmit: {
              validate()
            }
          )
        }
        .padding(.horizontal, padding)
        .navigationBarTitle(title, displayMode: .inline)
        .navigationBarItems(
          leading: mode != .change
            ? nil
            : Button(
              action: {
                isLocked = false
              },
              label: {
                Image(systemName: "xmark")
              }),
          trailing: Button(
            action: {
              validate()
            },
            label: {
              Image(systemName: "checkmark")
            }
          ).disabled(passcode.isEmpty)
        )
        .frame(
          width: geometry.frame(in: .global).width,
          height: geometry.frame(in: .global).height
        )
        .alert(isPresented: $isSaving) {
          Alert(
            title: Text(title),
            message: Text(
              "The passcode is stored only on the device. It can't be reset if you forget."),
            primaryButton: .destructive(Text("Save")) {
              Passcode().hashedPasscode = passcode
              isLocked = false
            }, secondaryButton: .cancel(Text("Cancel")))
        }
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification))
    { _ in
      isPortrait = UIDevice.current.orientation.isPortrait
    }
  }

  private var title: String {
    switch mode {
    case .unlock:
      return NSLocalizedString("Unlock", comment: "")
    case .change:
      return NSLocalizedString("Change passcode", comment: "")
    case .initial:
      return NSLocalizedString("Set passcode", comment: "")
    }
  }

  private func validate() {
    switch mode {
    case .initial:
      isSaving = true
    case .unlock:
      if Passcode().compare(passcode: passcode) {
        isLocked = false
      } else {
        hasError = true
      }
    case .change:
      isSaving = true
    }
  }
}

struct PasscodeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PasscodeView(mode: .unlock, isLocked: .constant(false))
    }
  }
}
