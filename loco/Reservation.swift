//
//  Reservation.swift
//  loco
//
//  Created by Rohan Nagesh on 7/21/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import Foundation

class Reservation {
    
    var merchantName: String
    var dateTime: NSDate
    var partySize: Int
    var customerFirstName: String
    var customerLastName: String
    var customerEmail: String
    var customerPhone: String
    var merchantCountry: String
    
    init(merchantName: String, dateTime: NSDate, partySize: Int, customerFirstName: String, customerLastName: String, customerEmail: String, customerPhone: String, merchantCountry: String) {
        self.merchantName = merchantName
        self.dateTime = dateTime
        self.partySize = partySize
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.customerEmail = customerEmail
        self.customerPhone = customerPhone
        self.merchantCountry = merchantCountry
    }
    
}

extension Reservation {
    
    //TODO: Make call to backend to fetch current time to grab an Uber now
    func getUberHailETA() -> Int {
        return 10
    }
}
