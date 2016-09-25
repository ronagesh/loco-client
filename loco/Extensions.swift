//
//  Extensions.swift
//  loco
//
//  Created by Rohan Nagesh on 7/21/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import Foundation
import Parse
import UberRides

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    
}

extension ProfileViewController {
    
    static func fetchFBProfilePic() {
        
        if let currentUser = PFUser.currentUser() {
            let fbID = currentUser["fb_id"]
            let profilePictureURL = NSURL(string: "https://graph.facebook.com/" +  String(fbID) + "/picture?type=normal")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let contents = NSData(contentsOfURL: profilePictureURL!) {
                    NSUserDefaults.standardUserDefaults().setObject(contents, forKey: "fbProfilePic")
                }
            }
        }
    }
}

//Fetches and stores the uber product ID corresponding to the user's budget rating and current location into NSUserDefaults
public func fetchUberProductID(userCurrentLocation: CLLocation, budgetRating: String) {
    let ridesClient = RidesClient()
    let desiredUberProduct = budgetToUberProdMap[budgetRating]
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        ridesClient.fetchProducts(pickupLocation: userCurrentLocation) { (products, response) in
            if let error = response.error {
                print("Error fetching uber products \(error)")
            } else {
                for product in products {
                    if product.name == desiredUberProduct {
                        if product.productID != nil {
                            print("Obtained Uber Product ID")
                            NSUserDefaults.standardUserDefaults().setObject(product.productID, forKey: "uberProductID")
                            break
                        }
                    }
                }
            }
        }
    }
}


public func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

