//
//  AdBannerView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/25.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {

    func makeUIView(context: Context) -> GADBannerView  {
        let view = GADBannerView(adSize: GADAdSizeBanner)

        #if DEBUG
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        #endif
        
        view.rootViewController = UIApplication.shared.windows.first?.rootViewController
        view.load(GADRequest())

        return view
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

struct AdBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdBannerView()
    }
}
