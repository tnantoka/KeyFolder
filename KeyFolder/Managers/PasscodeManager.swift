//
//  PasscodeManager.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/20.
//

import CryptoKit
import Foundation

class PasscodeManager {
  let passcodeKey = "passcodeKey"
  let salt = Constants.passcodeSalt

  var isConfigured: Bool {
    !hashedPasscode.isEmpty
  }

  var hashedPasscode: String {
    UserDefaults.standard.string(forKey: passcodeKey) ?? ""
  }

  func change(passcode: String) {
    UserDefaults.standard.set(hash(passcode: passcode), forKey: passcodeKey)
  }

  func compare(passcode: String) -> Bool {
    return hashedPasscode == hash(passcode: passcode)
  }

  private func hash(passcode: String) -> String {
    guard let data = "\(passcode)_\(salt)".data(using: .utf8) else { return "" }
    return SHA256.hash(data: data).description
  }
}
