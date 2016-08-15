//
//  Restaurant.swift
//  loco
//
//  Created by Rohan Nagesh on 7/18/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import Foundation
import CoreLocation

class Restaurant {
    
    var name: String
    var imageURL: String
    var cuisineType: RestaurantCuisines
    var neighborhood: String?
    var address: String
    var geocodedAddress: CLLocation?
    var budgetRating: RestaurantBudgetRatings
    var blurb: String?
    var reservation: Reservation?
    
    init(name: String, imageURL: String, cuisineType: RestaurantCuisines, address: String, budgetRating: RestaurantBudgetRatings) {
        self.name = name
        self.imageURL = imageURL
        self.cuisineType = cuisineType
        self.address = address
        self.budgetRating = budgetRating
    }
    
}

extension Restaurant {
    
    //TODO: Invoke backend to obtain ETA for user to leave now and arrive at this restaurant
    
    func getRideTime() -> Int {
        return 15
    }
    
}