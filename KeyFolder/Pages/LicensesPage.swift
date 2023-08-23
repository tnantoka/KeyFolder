//
//  LicensesView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/23.
//

import SwiftUI

private let sites = [
  ["name": "examples/city.jpg", "url": "https://pixabay.com/images/id-6599328/"],
  ["name": "examples/sunset.jpg", "url": "https://pixabay.com/photos/id-3314275/"],
  ["name": "examples/sky.mp4", "url": "https://pixabay.com/videos/id-80724/"],
  [
    "name": "googleads/swift-package-manager-google-mobile-ads",
    "url": "https://github.com/googleads/swift-package-manager-google-mobile-ads",
  ],
]

struct LicensesPage: View {
  @Binding var isShowing: Bool

  var body: some View {
    NavigationView {
      List {
        ForEach(sites.indices, id: \.self) { i in
          NavigationLink(
            destination: {
              WebView(url: URL(string: sites[i]["url"] ?? "")!)
            },
            label: {
              Text(sites[i]["name"] ?? "")
            }
          )
        }
      }
      .navigationBarTitle("Acknowledgements", displayMode: .inline)
      .navigationBarItems(
        leading: Button(
          action: {
            isShowing = false
          },
          label: {
            Image(systemName: "xmark")
          }
        )
      )
    }
  }
}

struct LicensesPage_Previews: PreviewProvider {
  static var previews: some View {
    LicensesPage(isShowing: .constant(false))
  }
}
