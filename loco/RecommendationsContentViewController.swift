//
//  RecommendationsContentViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class RecommendationsContentViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var merchantImage: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantCuisine: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var merchantDriveETA: UILabel!
    @IBOutlet weak var merchantBudgetRating: UILabel!
    @IBOutlet weak var merchantBlurb: UILabel!
    
    
    //MARK: Properties
    var restaurant: Restaurant!
    var reservation: Reservation!
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchantImage.image = UIImage(named: restaurant.imageURL)
        merchantName.text = restaurant.name
        merchantCuisine.text = restaurant.cuisineType.rawValue
        merchantAddress.text = restaurant.address
        merchantDriveETA.text = "\(restaurant.getRideTime()) min. drive away"
        merchantBudgetRating.text = restaurant.budgetRating.rawValue
        merchantBlurb.text = restaurant.blurb
        
    }
    

    @IBAction func goButtonPressed() {
        
        //TODO: Make backend call to lock/confirm reservation
        let res = Reservation(merchantName: "\(restaurant.name)", dateTime: NSDate(dateString: "2016-07-31T19:00:00"), partySize: 2, customerFirstName: "Rohan", customerLastName: "Nagesh", customerEmail: "ronagesh@gmail.com", customerPhone: "6506226720", merchantCountry: "US")
        
        reservation = res
        self.performSegueWithIdentifier("recommendationsToConfirmSchedule", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifer = segue.identifier {
            if identifer == "recommendationsToConfirmSchedule" {
                if let vc = segue.destinationViewController as? ConfirmScheduleViewController {
                    //Set properties
                    vc.bizName = restaurant.name
                    vc.bizAddress = restaurant.address
                    vc.bizDriveETA = restaurant.getRideTime()
                    vc.resTimeDisplay = reservation.dateTime.toShortTimeString()
                    vc.dropoffLocation = restaurant.geocodedAddress
                    
                    //Compute Uber Pickup time string
                    
                    let calendar = NSCalendar.currentCalendar()
                    let uberPickupTime = calendar.dateByAddingUnit(.Minute, value: reservation.getUberHailETA(), toDate: NSDate(), options: [])!
                    vc.uberPickupTimeDisplay = uberPickupTime.toShortTimeString()
                }
            }
        }
    }
}


