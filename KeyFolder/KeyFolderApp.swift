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

  @State private var isLocked = true

  let store = Store()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        FolderListView(isLocked: $isLocked)
        VStack(alignment: .leading) {
          Text("No item selected.")
            .font(.title2)
            .foregroundColor(.secondary)
          Spacer()
        }
      }
      .onChange(of: scenePhase) { phase in
        isLocked = true
      }
      .fullScreenCover(isPresented: $isLocked) {
        if PasscodeManager().isConfigured {
          UnlockPage(isShowing: $isLocked)
        } else {
          SetPasscodePage(isShowing: $isLocked)
        }
      }
      .environmentObject(store)
    }
  }
}
