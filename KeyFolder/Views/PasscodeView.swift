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
    @State private var isLandscape = UIDevice.current.orientation.isLandscape
    @State private var passcode = ""
    @State private var hasError = false

    var body: some View {
        NavigationView() {
            GeometryReader { geometry in
                VStack {
                    SecureField(NSLocalizedString("Passcode", comment: ""), text: $passcode)
                        .textFieldStyle(.roundedBorder)
                        .font(.title2)
                        .padding(.bottom, 16)
                        .disabled(true)
                        .foregroundColor(hasError ? .red : Color("KeypadButtonColor"))
                    KeypadView(
                        text: $passcode,
                        buttonSize: isLandscape ? geometry.size.height * 0.14 : geometry.size.width * 0.18,
                        onChange: {
                            hasError = false
                        },
                        onSubmit: {
                            validate()
                        }
                    )
                }
                .padding(.horizontal, geometry.size.width * (isLandscape ? 0.38 : 0.2))
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
            isLandscape = UIDevice.current.orientation.isLandscape
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
