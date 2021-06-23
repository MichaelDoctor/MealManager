//
//  GoogleAdMobManager.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-14.
//

import UIKit
import GoogleMobileAds

enum GoogleAdMobManager {
    
    static let sharedForDetail = createBanner()
    
    static func createBanner() -> GADBannerView {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        return banner
    }
    
    
    static func layoutAd(forView view: UIView, tabBarController: UITabBarController?, banner: GADBannerView = sharedForDetail) {
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
}
