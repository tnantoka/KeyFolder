//
//  AdManager.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/15.
//

import Foundation
import GoogleMobileAds
import AppTrackingTransparency

class AdManager {
    static let shared = AdManager()
    
    var isStarted = false
    
    private init() {
    }
    
    func start(callback: @escaping () -> Void) {
        if isStarted {
            callback()
        } else {
            requestIDFA {
                GADMobileAds.sharedInstance().start { [weak self] _ in
                    self?.isStarted = true
                    callback()
                }
            }
        }
    }
    
    private func requestIDFA(callback: @escaping () -> Void) {
        if UIApplication.shared.applicationState != .active {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.requestIDFA(callback: callback)
            }
            return
        }

        ATTrackingManager.requestTrackingAuthorization { _ in
            DispatchQueue.main.async {
                callback()
            }
        }
    }
}
