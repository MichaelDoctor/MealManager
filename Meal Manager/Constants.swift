//
//  Constants.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import Foundation
import GoogleMobileAds

struct K {
    
    static let preloadKey = "didPreloadCuisine"
    
    //MARK: - Storyboard constants
    struct Views {
        static let tabBarCtr = "TabBarController"
        
        static let cuisineRightCell = "CuisineRightCell"
        static let cuisineRightMenu = "CuisineRightMenu"
        static let cuisineRightDetail = "CuisineRightDetail"
        static let cuisineRightEdit = "CuisineRightDetailEdit"
        static let cuisineLeftMenu = "CuisineLeftMenu"
        static let cuisineLeftCell = "CuisineLeftCell"
        static let cuisinePlay = "CuisinePlay"
        static let cuisineRightNib = "CuisineCell"
        
        static let mealRightMenu = "MealRightMenu"
        static let mealRightCell = "MealRightCell"
        static let mealRightDetail = "MealRightDetail"
        static let mealLeftMenu = "MealLeftMenu"
        static let mealLeftCell = "MealLeftCell"
    }
    
    //MARK: - Colors
    struct Color {
        static let accent = "AccentColor"
        static let red = "MMRedColor"
        static let black = "MMBlackColor"
        static let white = "MMWhiteColor"
    }
    
    //MARK: - Filters
    struct CuisineFilter {
        static let all = "ALL"
        static let enable = "ENABLE"
        static let disable = "DISABLE"
    }
    
    struct MealFilter {
        static let all = "ALL"
        static let cook = "Eat In"
        static let order = "Eat Out"
    }
    
    //MARK: - Helper Functions
    
    static func createBanner() -> GADBannerView {
        let banner = GADBannerView()
        // replace later
        //        banner.adUnitID = "ca-app-pub-2009699556932262/4104921805"
        // added to plist
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        DispatchQueue.global(qos: .background).async {
            banner.load(GADRequest())
        }
        banner.backgroundColor = .white
        return banner
    }
    
    static func formatDate(_ date: Date) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }
    
    static func roundedButton(_ button: UIButton, bg: UIColor, tint: UIColor) {
        button.backgroundColor = bg
        button.layer.cornerRadius = 15.0
        button.tintColor = tint
//        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}
