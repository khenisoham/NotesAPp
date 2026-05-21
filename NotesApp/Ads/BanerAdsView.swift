

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> BannerView {
        
        let banner = BannerView(adSize: AdSizeBanner)
        
        banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
        
        banner.load(Request())
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        
    }
}

