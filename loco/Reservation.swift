//
//  Reservation.swift
//  loco
//
//  Created by Rohan Nagesh on 7/21/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import Foundation

class Reservation {

    var yelpBizID: String
    var yelpPermalink: String
    var reservationDate: String
    var reservationTime: String
    var uberHailTime: Int
    var driveTime: Int
    var totalTripTime: Int
    var partySize: Int
    var customerFirstName: String
    var customerLastName: String
    var customerEmail: String
    var customerPhone: String
    
    init (yelpBizID: String, yelpPermalink: String, reservationDate: String, reservationTime: String, partySize: Int, uberHailTime: Int, driveTime: Int, totalTripTime: Int) {
        self.yelpBizID = yelpBizID
        self.yelpPermalink = yelpPermalink
        self.reservationDate = reservationDate
        self.reservationTime = reservationTime
        self.partySize = partySize
        self.uberHailTime = uberHailTime
        self.driveTime = driveTime
        self.totalTripTime = totalTripTime

    }
    
    init(yelpBizID: String, yelpPermalink: String, reservationDate: String, reservationTime: String, partySize: Int, customerFirstName: String, customerLastName: String, customerEmail: String, customerPhone: String) {
        self.yelpBizID = yelpBizID
        self.yelpPermalink = yelpPermalink
        self.reservationDate = reservationDate
        self.reservationTime = reservationTime
        self.partySize = partySize
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.customerEmail = customerEmail
        self.customerPhone = customerPhone
        
    }
    
}

extension Reservation {
    
    //TODO: Make call to backend to fetch current time to grab an Uber now
    func getUberPickupTimeFormattedString() -> String {
        let calendar = NSCalendar.currentCalendar()
        let uberPickupTime = calendar.dateByAddingUnit(.Second, value: self.uberHailTime, toDate: NSDate(), options: [])!
        
        
        
        
        
        
    }
}
