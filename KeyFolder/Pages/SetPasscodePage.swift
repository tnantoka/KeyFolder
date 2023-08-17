//
//  SetPasscodePage.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/16.
//

import SwiftUI

struct SetPasscodePage: View {
  @Binding var isShowing: Bool

  @State private var passcode = ""
  @State private var isConfirmed = false

  var body: some View {
    NavigationView {
      PasscodeForm(
        passcode: $passcode,
        onConfirm: onConfirm
      )
      .navigationBarTitle("Set passcode", displayMode: .inline)
      .navigationBarItems(
        trailing: Button(
          action: onConfirm,
          label: {
            Image(systemName: "checkmark")
          }
        ).disabled(passcode.isEmpty)
      )
      .alert(isPresented: $isConfirmed) {
        Alert(
          title: Text("Set passcode"),
          message: Text(
            "The passcode is stored only on the device. It can't be reset if you forget."),
          primaryButton: .destructive(Text("Save")) {
            PasscodeManager().hashedPasscode = passcode
            isShowing = false
          },
          secondaryButton: .cancel(Text("Cancel"))
        )
      }
    }
  }

  func onConfirm() {
    isConfirmed = true
  }
}

struct SetPasscodePage_Previews: PreviewProvider {
  static var previews: some View {
    SetPasscodePage(isShowing: .constant(true))
  }
}
