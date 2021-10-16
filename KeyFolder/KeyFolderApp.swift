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

    @State private var isLock = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FolderListView()
            }
            .onChange(of: scenePhase) { phase in
                isLock = true
            }
            .fullScreenCover(isPresented: $isLock) {
                PasscodeView(isLocked: $isLock)
            }
        }
    }
}
