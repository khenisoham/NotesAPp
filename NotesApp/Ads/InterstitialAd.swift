
import GoogleMobileAds
import UIKit

class InterstitialAdManager: NSObject {

    static let shared = InterstitialAdManager()

    private var interstitial: InterstitialAd?

    func loadAd() {

        let request = Request()

        InterstitialAd.load(
            with: "ca-app-pub-3940256099942544/4411468910",
            request: request
        ) { ad, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            self.interstitial = ad
        }
    }

    func showAd(completion: @escaping () -> Void) {

        guard let interstitial = interstitial else {
            completion()
            return
        }

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {

            interstitial.present(from: root)

            self.interstitial = nil

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                completion()

                self.loadAd()
            }
        }
    }
}
