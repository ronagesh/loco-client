//
//  RecommendationsContentViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse
import Kingfisher


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

    override func viewDidLoad() {
        super.viewDidLoad()
        merchantImage.kf_setImageWithURL(NSURL(string: restaurant.imageURL)!)
        merchantImage.kf_showIndicatorWhenLoading = true
        merchantName.text = restaurant.name
        merchantCuisine.text = restaurant.cuisineType.rawValue
        merchantAddress.text = restaurant.address
        merchantDriveETA.text = "\(restaurant.getRideTime()) min. drive away"
        merchantBudgetRating.text = restaurant.budgetRating.rawValue
        merchantBlurb.text = restaurant.blurb
        
    }
    

    @IBAction func goButtonPressed() {
        
        //TODO: Make backend call to lock/confirm reservation
       // let res = Reservation(merchantName: "\(restaurant.name)", dateTime: NSDate(dateString: "2016-07-31T19:00:00"), partySize: 2, customerFirstName: "Rohan", customerLastName: "Nagesh", customerEmail: "ronagesh@gmail.com", customerPhone: "6506226720", merchantCountry: "US")
        
        
        if PFUser.currentUser()?.email != nil && PFUser.currentUser()?["phone"] != nil {
            print("Transitioning from recs to confirm schedule")
            print("Current PF User's email \(PFUser.currentUser()!.email)")
            print("Current PF User \(PFUser.currentUser()?.sessionToken)")
            self.performSegueWithIdentifier("recsToConfirmSchedule", sender: self)
        } else {
            self.performSegueWithIdentifier("recsToLogin", sender: self)
            print("Transitioning from recs to login")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Compute Uber Pickup time string
        let calendar = NSCalendar.currentCalendar()
        let uberPickupTime = calendar.dateByAddingUnit(.Minute, value: reservation.getUberHailETA(), toDate: NSDate(), options: [])!
        
        if let identifier = segue.identifier {
            if identifier == "recsToConfirmSchedule" {
                if let vc = segue.destinationViewController as? ConfirmScheduleViewController {
                    //Set properties
                    vc.bizName = restaurant.name
                    vc.bizAddress = restaurant.address
                    vc.bizDriveETA = restaurant.getRideTime()
                    vc.resTimeDisplay = restaurant.reservation.dateTime.toShortTimeString()
                    vc.dropoffLocation = restaurant.geocodedAddress
                    vc.uberPickupTimeDisplay = uberPickupTime.toShortTimeString()
                }
            } else if identifier == "recsToLogin" {
                if let vc = segue.destinationViewController as? LoginViewController {
                    vc.bizName = restaurant.name
                    vc.bizAddress = restaurant.address
                    vc.bizDriveETA = restaurant.getRideTime()
                    vc.resTimeDisplay = reservation.dateTime.toShortTimeString()
                    vc.dropoffLocation = restaurant.geocodedAddress
                    vc.uberPickupTimeDisplay = uberPickupTime.toShortTimeString()
                }

            }
        }
    }
}


