//
//  AdBannerView.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/25.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: View {
    var body: some View {
        let height = [50, 100].randomElement() ?? 50
        AdBannerViewWithController(height: height).frame(height: CGFloat(height))
    }
}

struct AdBannerViewWithController: UIViewControllerRepresentable {
    let height: Int

    func makeUIViewController(context: UIViewControllerRepresentableContext<AdBannerViewWithController>) -> UIViewController {
        let controller = UIViewController()

        let view = GADBannerView(adSize: height == 50 ? GADAdSizeBanner : GADAdSizeLargeBanner)

        #if DEBUG
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        view.adUnitID = Constants.adUnitID
        #endif

        view.rootViewController = controller
        #if DEBUG
//        view.load(GADRequest())
        #else
        view.load(GADRequest())
        #endif

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
