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
  private let passcodeKey = "passcodeKey"
  private let isConfiguredKey = "isConfiguredKey"

  private let salt = Constants.passcodeSalt
  private let keychain = KeychainSwift()

  var isConfigured: Bool {
    get {
      UserDefaults.standard.bool(forKey: isConfiguredKey)
    }
    set(newValue) {
      UserDefaults.standard.set(newValue, forKey: isConfiguredKey)
    }
  }

  private var hashedPasscode: String {
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
