// (c) Facebook, Inc. and its affiliates. Confidential and proprietary.

import os
import UIKit
import FBAudienceNetwork

protocol FullscreenAd {
    func load()
    func show(from viewController: UIViewController)
}

extension FBInterstitialAd: FullscreenAd {
    func show(from viewController: UIViewController) {
        self.show(fromRootViewController: viewController)
    }
}

extension FBRewardedVideoAd: FullscreenAd {
    func show(from viewController: UIViewController) {
        self.show(fromRootViewController: viewController)
    }
}

extension FBRewardedInterstitialAd: FullscreenAd {
    func show(from viewController: UIViewController) {
        self.show(fromRootViewController: viewController, animated: true)
    }
}

enum FullscreenAdType {
    case interstitial, rewardedVideo, rewardedInterstitial

    var title: String {
        switch self {
        case .interstitial:
            return "Interstitial"
        case .rewardedVideo:
            return "Rewarded video"
        case .rewardedInterstitial:
            return "Rewarded interstitial"
        }
    }
}

final class FullscreenAdSampleViewController: UIViewController {

    // MARK: - Properties

    private var adType: FullscreenAdType
    private var ad: FullscreenAd? {
        didSet {
            if let ad = ad as? FBInterstitialAd {
                ad.delegate = self
            } else if let ad = ad as? FBRewardedVideoAd {
                ad.delegate = self
            } else if let ad = ad as? FBRewardedInterstitialAd {
                ad.delegate = self
            }
        }
    }

    private var state: LoadingState = .initial {
        didSet {
            switch state {
            case .initial:
                bottomBarView.set(buttonTitle: "Load Ad", isEnabled: true)
            case .loading:
                bottomBarView.set(buttonTitle: "Loading", isEnabled: false)
            case .loaded:
                bottomBarView.set(buttonTitle: "Show Ad", isEnabled: true)
            case .error(let message):
                bottomBarView.set(buttonTitle: "Retry", isEnabled: true)
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                present(alert, animated: true)
            }
        }
    }

    @IBOutlet private var bottomBarView: BottomBarView!

    // MARK: - Lifecycle and Setup

    static func create(adType: FullscreenAdType) -> UIViewController {
        let vc: FullscreenAdSampleViewController = FullscreenAdSampleViewController.create()
        vc.adType = adType
        return vc
    }

    required init?(coder: NSCoder) {
        self.adType = .interstitial
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ad = createNewAd()
        navigationItem.title = "\(adType.title) Ad"

        bottomBarView.tapHandler = { [weak self] in
            self?.handleTap()
        }
    }

    // MARK: - Helpers

    private func handleTap() {
        switch state {
        case .initial:
            loadAd()
        case .loading, .error:
            ad = createNewAd()
            loadAd()
        case .loaded:
            ad?.show(from: self)
        }
    }

    private func loadAd() {
        state = .loading
        ad?.load()
    }

    private func createNewAd() -> FullscreenAd {
        let placementID = "IMG_16_9_APP_INSTALL#204905456199565_2276019375754819"
        switch adType {
        case .interstitial:
            return FBInterstitialAd(placementID: placementID)
        case .rewardedVideo:
            return FBRewardedVideoAd(placementID: placementID)
        case .rewardedInterstitial:
            return FBRewardedInterstitialAd(placementID: placementID)
        }
    }
}

// MARK: - FBInterstitialAdDelegate

extension FullscreenAdSampleViewController: FBInterstitialAdDelegate {

    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        ad = interstitialAd
        state = .loaded
    }

    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        state = .error(message: error.localizedDescription)
    }

    func interstitialAdDidClick(_ interstitialAd: FBInterstitialAd) {

    }

    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        ad = createNewAd()
        state = .initial
    }

    func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {

    }

    func interstitialAdWillLogImpression(_ interstitialAd: FBInterstitialAd) {

    }
}

// MARK: - FBRewardedVideoAdDelegate

extension FullscreenAdSampleViewController: FBRewardedVideoAdDelegate {

    func rewardedVideoAdDidLoad(_ rewardedVideoAd: FBRewardedVideoAd) {
        ad = rewardedVideoAd
        state = .loaded
    }

    func rewardedVideoAd(_ rewardedVideoAd: FBRewardedVideoAd, didFailWithError error: Error) {
        state = .error(message: error.localizedDescription)
    }

    func rewardedVideoAdDidClick(_ rewardedVideoAd: FBRewardedVideoAd) {

    }

    func rewardedVideoAdDidClose(_ rewardedVideoAd: FBRewardedVideoAd) {
        ad = createNewAd()
        state = .initial
    }

    func rewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: FBRewardedVideoAd) {

    }

    func rewardedVideoAdVideoComplete(_ rewardedVideoAd: FBRewardedVideoAd) {

    }

    func rewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: FBRewardedVideoAd) {

    }

    func rewardedVideoAdWillClose(_ rewardedVideoAd: FBRewardedVideoAd) {

    }

    func rewardedVideoAdWillLogImpression(_ rewardedVideoAd: FBRewardedVideoAd) {

    }
}

extension FullscreenAdSampleViewController: FBRewardedInterstitialAdDelegate {
    func rewardedInterstitialAdDidLoad(_ rewardedInterstitialAd: FBRewardedInterstitialAd) {
        os_log("Rewarded interstitial ad was loaded. Can present now.")
        ad = rewardedInterstitialAd
        state = .loaded
    }
    
    func rewardedInterstitialAd(_ rewardedInterstitialAd: FBRewardedInterstitialAd, didFailWithError error: Error) {
        let error = error as NSError
        os_log("Rewarded interstitial failed to load with error: %@", error.description)
        state = .error(message: "Rewarded interstitial ad failed to load. \(error.localizedDescription)")
    }
    
    func rewardedInterstitialAdDidClick(_ rewardedInterstitialAd: FBRewardedInterstitialAd) {
        os_log("Rewarded interstitial was clicked.")
    }
    
    func rewardedInterstitialAdDidClose(_ rewardedInterstitialAd: FBRewardedInterstitialAd) {
        os_log("Rewarded interstitial closed.")
    }
    
    func rewardedInterstitialAdWillClose(_ rewardedInterstitialAd: FBRewardedInterstitialAd) {
        os_log("Rewarded interstitial will close.")
    }
    
    func rewardedInterstitialAdWillLogImpression(_ rewardedInterstitialAd: FBRewardedInterstitialAd) {
        os_log("Rewarded impression is being captured.")
    }
    
    func rewardedInterstitialAdVideoComplete(_ rewardedInterstitialAd: FBRewardedInterstitialAd) {
        os_log("Rewarded interstitial ad video completed.")
    }
}
