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
    enum Views {
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
    enum Color {
        static let accent = "AccentColor"
        static let red = "MMRedColor"
        static let black = "MMBlackColor"
        static let white = "MMWhiteColor"
    }
    
    //MARK: - Images
    enum Images {
        static let icon = "MMIcon"
        static let welcomeScreen = "WelcomeScreen"
        static let customScreen = "CustomScreen"
        static let cuisineScreen = "CuisineScreen"
    }
    
    //MARK: - Filters
    enum CuisineFilter {
        static let all = "ALL"
        static let enable = "ENABLE"
        static let disable = "DISABLE"
    }
    
    enum MealFilter {
        static let all = "ALL"
        static let cook = "Cooked"
        static let order = "Ordered"
    }
    
    //MARK: - Helper Functions
    static func formatDate(_ date: Date) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }
}
