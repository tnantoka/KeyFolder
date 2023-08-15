//
//  LicensesView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/23.
//

import SwiftUI

private let sites = [
    ["name": "examples/city.jpg", "url": "https://pixabay.com/images/id-6599328/"],
    ["name": "examples/sky.mp4", "url": "https://pixabay.com/videos/id-80724/"],
    ["name": "googleads/swift-package-manager-google-mobile-ads", "url": "https://github.com/googleads/swift-package-manager-google-mobile-ads"],
]

struct LicensesView: View {
    @Binding var isShowing: Bool
    @State var url = URL(string: sites[0]["url"] ?? "")!

    var body: some View {
        NavigationView() {
            List {
                ForEach(0..<sites.count, id: \.self) { i in
                    NavigationLink(destination: {
                        WebView(url: URL(string: sites[i]["url"] ?? "")!)
//                        SafariView(url: URL(string: sites[i]["url"] ?? "")!)
                    }) {
                        Text(sites[i]["name"] ?? "")
                        
                    }
                }
            }
                .navigationBarTitle("Acknowledgements", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark")
                    }
                )
        }
    }
}

struct LicensesView_Previews: PreviewProvider {
    static var previews: some View {
        LicensesView(isShowing: .constant(false))
    }
}
