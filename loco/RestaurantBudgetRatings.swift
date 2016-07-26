//
//  RestaurantBudgetRatings.swift
//  loco
//
//  Created by Rohan Nagesh on 7/18/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import Foundation

enum RestaurantBudgetRatings: String {
    case Smart = "Smart"
    case Upscale = "Upscale"
    case Luxe = "Luxe"
}

extension RestaurantBudgetRatings {
    
    static var budgetToUberProdMap: [RestaurantBudgetRatings: String] {
        get {
            return [RestaurantBudgetRatings.Smart: "uberX", RestaurantBudgetRatings.Upscale: "UberSELECT", RestaurantBudgetRatings.Luxe: "UberBLACK"]
        }
    }
    
    static func getUberProductForBudgetRating(rating: String) -> String? {
        
        switch rating {
        case RestaurantBudgetRatings.Smart.rawValue:
            return budgetToUberProdMap[RestaurantBudgetRatings.Smart]
        case RestaurantBudgetRatings.Upscale.rawValue:
            return budgetToUberProdMap[RestaurantBudgetRatings.Upscale]
        case RestaurantBudgetRatings.Luxe.rawValue:
            return budgetToUberProdMap[RestaurantBudgetRatings.Luxe]
        default:
            print("Error obtaining uber product for given budget rating string")
            return nil
        }
    }
}

