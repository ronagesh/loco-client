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
    var userCurrentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        merchantImage.kf_setImageWithURL(NSURL(string: restaurant.imageURL)!)
        merchantImage.kf_showIndicatorWhenLoading = true
        merchantName.text = restaurant.name
        merchantCuisine.text = restaurant.cuisineType.rawValue
        if restaurant.neighborhood != "" {
            merchantAddress.text = restaurant.neighborhood
        } else {
            merchantAddress.text = restaurant.address
        }
        
        merchantDriveETA.text = "\(restaurant.reservation.driveTime / 60) min. drive away"
        merchantBudgetRating.text = restaurant.budgetRating.rawValue
        merchantBlurb.text = restaurant.blurb
        
    }
    

    @IBAction func goButtonPressed() {
        
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
        
        if let identifier = segue.identifier {
            if identifier == "recsToConfirmSchedule" {
                if let vc = segue.destinationViewController as? ConfirmScheduleViewController {
                    //Set properties
                    vc.restaurant = restaurant
                    vc.userCurrentLocation = userCurrentLocation
                }
            } else if identifier == "recsToLogin" {
                if let vc = segue.destinationViewController as? LoginViewController {
                    vc.restaurant = restaurant
                    vc.userCurrentLocation = userCurrentLocation
                }
            }
        }
    }
}


