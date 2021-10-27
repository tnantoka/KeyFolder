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
//            GADMobileAds.sharedInstance().start(completionHandler: nil)
        #else
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        #endif

        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let foldersURL = documentsURL.appendingPathComponent("folders")
            if !FileManager.default.fileExists(atPath: foldersURL.path) {
                do {
                    let exampleURL = foldersURL.appendingPathComponent("example")
                    try FileManager.default.createDirectory(at: exampleURL, withIntermediateDirectories: true)
                    try [
                        Bundle.main.url(forResource: "city", withExtension: "jpg"),
                        Bundle.main.url(forResource: "sky", withExtension: "mp4"),
                    ].forEach { url in
                        if let url = url {
                            try FileManager.default.copyItem(at: url, to: exampleURL.appendingPathComponent(url.lastPathComponent))
                        }
                    }
                } catch {
                }
            }
        }
        
        return true
    }
}
