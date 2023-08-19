//
//  KeyFolderApp.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/16.
//

import SwiftUI

@main
struct KeyFolderApp: App {
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
      .onReceive(
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
      ) { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          isLocked = true
        }
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
