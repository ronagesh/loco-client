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
    var customerFirstName: String?
    var customerLastName: String?
    var customerEmail: String?
    var customerPhone: String?
    var cancellationURL: String?
    
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
    
    init(yelpBizID: String, yelpPermalink: String, reservationDate: String, reservationTime: String, partySize: Int, uberHailTime: Int, driveTime: Int, totalTripTime: Int, customerFirstName: String, customerLastName: String, customerEmail: String, customerPhone: String) {
        self.yelpBizID = yelpBizID
        self.yelpPermalink = yelpPermalink
        self.reservationDate = reservationDate
        self.reservationTime = reservationTime
        self.partySize = partySize
        self.uberHailTime = uberHailTime
        self.driveTime = driveTime
        self.totalTripTime = totalTripTime
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
        return uberPickupTime.toShortTimeString()
    }
    
    //Takes military time string and returns formatted time string (i.e. 1900 = 7:00pm)
    func formatReservationTimeString() -> String {
        if var intTime = Int(self.reservationTime) {
            if intTime >= 1200 {
                if intTime >= 1300 {
                    intTime -= 1200
                }
                let stringTime = String(intTime)
                var hourEndIndex: String.CharacterView.Index
                if intTime >= 1000 {
                    hourEndIndex = stringTime.startIndex.advancedBy(2)
                } else {
                    hourEndIndex = stringTime.startIndex.advancedBy(1)
                }
                let hourString = stringTime.substringToIndex(hourEndIndex)
                let minuteString = stringTime.substringFromIndex(hourEndIndex)
                return hourString + ":" + minuteString + " PM"
            } else {
                let hourEndIndex = self.reservationTime.startIndex.advancedBy(1)
                let hourString = self.reservationTime.substringToIndex(hourEndIndex)
                let minuteString = self.reservationTime.substringFromIndex(hourEndIndex)
                return hourString + ":" + minuteString + " AM"
            }
        } else {
            return ""
        }
    }
}
