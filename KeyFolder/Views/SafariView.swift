//
//  SafariView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/23.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        
        print("debug: \(url)")
        controller.dismissButtonStyle = .close
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        print("debug: 2 \(url)")
    }
}


struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://example.com/")!)
    }
}
