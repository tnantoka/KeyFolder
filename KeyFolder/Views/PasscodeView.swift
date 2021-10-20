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
    
    @State private var passcode = ""
    @FocusState private var isFocused
    @Binding var isLocked: Bool

    var body: some View {
        NavigationView() {
            VStack {
                SecureField("Passcode", text: $passcode)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .font(.largeTitle)
                    .focused($isFocused)
            }
            .padding(.horizontal)
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarItems(
                leading: mode != .change ? nil : Button(action: {
                    isLocked = false
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: {
                    switch mode {
                    case .initial:
                        Passcode().hashedPasscode = passcode
                        isLocked = false
                    case .unlock:
                        if (Passcode().compare(passcode: passcode)) {
                            isLocked = false
                        }
                    case .change:
                        Passcode().hashedPasscode = passcode
                        isLocked = false
                    }
                }) {
                    Image(systemName: "checkmark")
                })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  isFocused = true
              }
            }
        }
    }
    
    private var title: String {
        switch mode {
        case .unlock:
            return "Unlock"
        case .change:
            return "Change"
        case .initial:
            return "Set"
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
