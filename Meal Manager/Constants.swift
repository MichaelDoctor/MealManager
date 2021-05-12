//
//  Constants.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import Foundation

struct K {
    
    static let preloadKey = "didPreloadCuisine"
    
    struct Views {
        static let tabBarCtr = "TabBarController"
        static let cellIdentifierCuisine = "CuisineCell"
        static let cellIdentifierMeal = "MealCell"
    }
    
    struct Color {
        static let accent = "AccentColor"
        static let red = "MMRedColor"
        static let black = "MMBlackColor"
        static let white = "MMWhiteColor"
    }
    
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
    
}
