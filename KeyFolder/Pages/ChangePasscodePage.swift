//
//  ChangePasscodePage.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/18.
//

import SwiftUI

struct ChangePasscodePage: View {
  @Binding var isShowing: Bool

  @State private var passcode = ""
  @State private var isConfirmed = false

  var body: some View {
    NavigationView {
      PasscodeForm(
        passcode: $passcode,
        onConfirm: onConfirm,
        hasError: false
      )
      .navigationBarTitle("Change passcode", displayMode: .inline)
      .navigationBarItems(
        leading: Button(
          action: {
            isShowing = false
          },
          label: {
            Image(systemName: "xmark")
          }
        ),
        trailing: Button(
          action: onConfirm,
          label: {
            Image(systemName: "checkmark")
          }
        ).disabled(passcode.isEmpty)
      )
      .alert(isPresented: $isConfirmed) {
        Alert(
          title: Text("Change passcode"),
          message: Text(
            "The passcode is stored only on the device. It can't be recovered if you forget."),
          primaryButton: .destructive(Text("Save")) {
            PasscodeManager().change(passcode: passcode)
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

struct ChangePasscodePage_Previews: PreviewProvider {
  static var previews: some View {
    ChangePasscodePage(isShowing: .constant(true))
  }
}
