//
//  KeyFolderApp.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

@main
struct KeyFolderApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @State private var isLocked = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FolderListView(isLocked: $isLocked)
            }
            .onChange(of: scenePhase) { phase in
                isLocked = true
            }
            .fullScreenCover(isPresented: $isLocked) {
                PasscodeView(mode: Passcode().isConfigured ? .unlock : .initial, isLocked: $isLocked)
            }
            .environmentObject(Store())
        }
    }
}
