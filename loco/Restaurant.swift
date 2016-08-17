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
    var reservation: Reservation
    
    init(name: String, imageURL: String, cuisineType: RestaurantCuisines, address: String, neighborhood: String?, budgetRating: RestaurantBudgetRatings, reservation: Reservation) {
        self.name = name
        self.imageURL = imageURL
        self.cuisineType = cuisineType
        self.address = address
        self.neighborhood = neighborhood
        self.budgetRating = budgetRating
        self.reservation = reservation
    }
    
}