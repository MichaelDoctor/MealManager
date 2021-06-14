//
//  Constants.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import Foundation
import GoogleMobileAds

enum K {
    
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
    
    static func formatDate(_ date: Date) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }
    
    static func roundedButton(_ button: UIButton, bg: UIColor, tint: UIColor) {
        button.backgroundColor = bg
        button.layer.cornerRadius = 12.0
        button.tintColor = tint
        
//        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}
