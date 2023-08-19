//
//  PasscodeManager.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/20.
//

import CryptoKit
import Foundation
import KeychainSwift

class PasscodeManager {
  let passcodeKey = "passcodeKey"
  let salt = Constants.passcodeSalt
  let keychain = KeychainSwift()

  var isConfigured: Bool {
    !hashedPasscode.isEmpty
  }

  var hashedPasscode: String {
    keychain.get(passcodeKey) ?? ""
  }

  func change(passcode: String) {
    keychain.set(hash(passcode: passcode), forKey: passcodeKey)
  }

  func compare(passcode: String) -> Bool {
    return hashedPasscode == hash(passcode: passcode)
  }

  private func hash(passcode: String) -> String {
    guard let data = "\(passcode)_\(salt)".data(using: .utf8) else { return "" }
    return SHA256.hash(data: data).description
  }
}
