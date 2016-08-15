//
//  ReceiptPageViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/26/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation
import UberRides
import Parse

class ReceiptPageViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var merchantDriveETA: UILabel!

    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var pickupDetails: UILabel!
    @IBOutlet weak var reservationDetails: UILabel!
    
    //MARK: Properties
    var bizName: String!
    var bizAddress: String!
    var bizDriveETA: Int!
    var uberPickupTimeDisplay: String!
    var resTimeDisplay: String!
    
    var transportationMode: Int!
    var userStartingLocation: CLLocation?
    var uberProductID: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    
        merchantName.text = bizName
        merchantAddress.text = bizAddress
        merchantDriveETA.text = "\(bizDriveETA) min. drive away"
        reservationDetails.text = "\(resTimeDisplay) Reservation at \(bizName)"
        greeting.text = "Enjoy your date night \(PFUser.currentUser()!["first_name"]!). Go loco!"
        
        if transportationMode == 0 {
            pickupDetails.text = "\(uberPickupTimeDisplay) Uber pickup"
            
            // Pass in a UIViewController to modally present the Uber Ride Request Widget over
            var builder = RideParametersBuilder()
            let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
            
            builder.setPickupToCurrentLocation()
            
            if userStartingLocation != nil {
                print("Setting dropoff location: \(userStartingLocation.debugDescription)")
                builder = builder.setDropoffLocation(userStartingLocation!)
            }
            
            
            //Prefill uber product for user's budget rating
            if uberProductID != nil {
                builder = builder.setProductID(uberProductID!)
            }
            
            //Create Uber button
            print("Creating uber button")
            let uberButton = RideRequestButton(rideParameters: builder.build(), requestingBehavior: behavior)
            uberButton.setButtonTitle("Ride back home")
            uberButton.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(uberButton)
            ConfirmScheduleViewController.setConstraintsForSubmitButton(uberButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
            
        } else {
            pickupDetails.text = "\(bizDriveETA) minute drive to \(bizName)"
        }
        
        delay(3.0) {
            self.performSegueWithIdentifier("thankYouToReview", sender: self)
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
