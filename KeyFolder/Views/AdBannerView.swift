//
//  AdBannerView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/25.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: View {
    @State var onReady = false
    
    var body: some View {
        let height = [50, 100].randomElement() ?? 50
        
        if onReady {
            AdBannerViewWithController(height: height).frame(height: CGFloat(height))
        } else {
            VStack {}
                .onAppear {
                    AdManager.shared.start { onReady = true }
                }
        }
    }
}

struct AdBannerViewWithController: UIViewControllerRepresentable {
    let height: Int

    func makeUIViewController(context: UIViewControllerRepresentableContext<AdBannerViewWithController>) -> UIViewController {
        let controller = UIViewController()

        let view = GADBannerView(adSize: height == 50 ? GADAdSizeBanner : GADAdSizeLargeBanner)

        view.adUnitID = Constants.adUnitID

        view.rootViewController = controller
        if (Constants.isEnabledAd) {
            view.load(GADRequest())
        }

        controller.view.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "view": view
        ]
        let horizontal = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[view]-0-|",
            options: [],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activate(horizontal)

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct AdBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdBannerView()
    }
}
