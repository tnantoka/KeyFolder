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

    var body: some View {
        NavigationView() {
            GeometryReader { geometry in
                let isPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
                let buttonSize = isPhone
                  ? (isPortrait ? geometry.size.width * 0.18 : geometry.size.height * 0.14)
                  : (isPortrait ? geometry.size.width * 0.14 : geometry.size.height * 0.14)
                let padding = isPhone
                  ? geometry.size.width * (isPortrait ? 0.2 : 0.38)
                  : geometry.size.width * (isPortrait ? 0.28 : 0.36)
                VStack {
                    SecureField(NSLocalizedString("Passcode", comment: ""), text: $passcode)
                        .textFieldStyle(.roundedBorder)
                        .font(isPhone ? .title2 : .largeTitle)
                        .padding(.bottom, 16)
                        .disabled(true)
                        .foregroundColor(hasError ? .red : Color("KeypadButtonColor"))
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
                    leading: mode != .change ? nil : Button(action: {
                        isLocked = false
                    }) {
                        Image(systemName: "xmark")
                    },
                    trailing: Button(action: {
                        validate()
                    }) {
                        Image(systemName: "checkmark")
                    }.disabled(passcode.isEmpty))
                .frame(
                    width: geometry.frame(in: .global).width,
                    height: geometry.frame(in: .global).height
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
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
            Passcode().hashedPasscode = passcode
            isLocked = false
        case .unlock:
            if (Passcode().compare(passcode: passcode)) {
                isLocked = false
            } else {
                hasError = true
            }
        case .change:
            Passcode().hashedPasscode = passcode
            isLocked = false
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
