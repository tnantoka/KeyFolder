//
//  UnlockPage.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/18.
//

import SwiftUI

struct UnlockPage: View {
  @Binding var isShowing: Bool

  @State private var passcode = ""
  @State private var hasError = false

  var body: some View {
    NavigationView {
      PasscodeForm(
        passcode: $passcode,
        onConfirm: onConfirm,
        hasError: hasError
      )
      .navigationBarTitle("Unlock", displayMode: .inline)
      .navigationBarItems(
        trailing: Button(
          action: onConfirm,
          label: {
            Image(systemName: "checkmark")
          }
        ).disabled(passcode.isEmpty)
      )
    }
  }

  func onConfirm() {
    if PasscodeManager().compare(passcode: passcode) {
      isShowing = false
    } else {
      hasError = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        passcode = ""
        hasError = false
      }
    }
  }
}

struct UnlockPage_Previews: PreviewProvider {
  static var previews: some View {
    UnlockPage(isShowing: .constant(true))
  }
}
