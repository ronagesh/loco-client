//
//  Review.swift
//  loco
//
//  Created by Rohan Nagesh on 8/21/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import Foundation

class Review {
    
    var merchantImageURL: String
    var merchantName: String
    var reservationDate: String
    var rating: Double
    
    init(merchantImageURL: String, merchantName: String, reservationDate: String, rating: Double) {
        self.merchantImageURL = merchantImageURL
        self.merchantName = merchantName
        self.reservationDate = reservationDate
        self.rating = rating
    }
    
}