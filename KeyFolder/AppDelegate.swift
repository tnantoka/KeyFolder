//
//  AppDelegate.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        #if DEBUG
            if (Constants.enableAd) {
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        #else
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        #endif
        
        return true
    }
}
