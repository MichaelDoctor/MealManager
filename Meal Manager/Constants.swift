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
        
        static let cuisineRightCell = "CuisineRightCell"
        static let cuisineRightMenu = "CuisineRightMenu"
        static let cuisineRightDetail = "CuisineRightDetail"
        static let cuisineLeftMenu = "CuisineLeftMenu"
        static let cuisineLeftCell = "CuisineLeftCell"
        
        static let mealRightMenu = "MealRightMenu"
        static let mealRightCell = "MealRightCell"
        static let mealRightDetail = "MealRightDetail"
        static let mealLeftMenu = "MealLeftMenu"
        static let mealLeftCell = "MealLeftCell"
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
