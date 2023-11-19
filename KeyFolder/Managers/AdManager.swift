//
//  AdManager.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/15.
//

import AppTrackingTransparency
import Foundation
import GoogleMobileAds
import UserMessagingPlatform

class AdManager {
  static let shared = AdManager()

  private var isStarted = false

  private init() {}

  func start(callback: @escaping () -> Void) {
    if isStarted {
      callback()
    } else {
      requestTracking {
        GADMobileAds.sharedInstance().start { [weak self] _ in
          self?.isStarted = true
          callback()
        }
      }
    }
  }

  private func requestTracking(callback: @escaping () -> Void) {
    if UIApplication.shared.applicationState != .active {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
        self?.requestTracking(callback: callback)
      }
      return
    }

    requestGDPR { [weak self] in
      self?.requestIDFA(callback: callback)
    }
  }

  private func requestIDFA(callback: @escaping () -> Void) {
    ATTrackingManager.requestTrackingAuthorization { _ in
      DispatchQueue.main.async {
        callback()
      }
    }
  }

  private func requestGDPR(callback: @escaping () -> Void) {
    let parameters = UMPRequestParameters()
    parameters.tagForUnderAgeOfConsent = false

    #if DEBUG
      if Constants.debugGDPR {
        let debugSettings = UMPDebugSettings()
        debugSettings.geography = .EEA
        parameters.debugSettings = debugSettings
      }
    #endif

    UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
      [weak self] requestConsentError in
      guard self != nil else { return }
      guard requestConsentError == nil else { return }
      guard
        let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
          .windows.first?.rootViewController
      else { return }

      UMPConsentForm.loadAndPresentIfRequired(from: rootViewController) { loadAndPresentError in
        guard loadAndPresentError == nil else { return }

        if UMPConsentInformation.sharedInstance.canRequestAds {
          callback()
        }
      }

      if UMPConsentInformation.sharedInstance.canRequestAds {
        callback()
      }
    }
  }
}
