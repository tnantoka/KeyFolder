//
//  WebView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView(frame: .zero)

        let req = URLRequest(url: url)
        view.load(req)

        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: URL(string: "https://example.com/")!)
    }
}
