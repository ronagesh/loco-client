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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let nav = self.navigationController as? ReceiptPageNavController {
            merchantName.text = nav.bizName
            merchantAddress.text = nav.bizAddress
            merchantDriveETA.text = "\(nav.bizDriveETA) min. drive away"
            reservationDetails.text = "\(nav.resTimeDisplay) Reservation at \(nav.bizName)"
            greeting.text = "Enjoy your date night \(PFUser.currentUser()!["first_name"]!). Go loco!"
            
            if nav.transportationMode == 0 {
                pickupDetails.text = "\(nav.uberPickupTimeDisplay) Uber pickup"
                
                // Pass in a UIViewController to modally present the Uber Ride Request Widget over
                var builder = RideParametersBuilder()
                let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
                
                builder.setPickupToCurrentLocation()
                
                if nav.userStartingLocation != nil {
                    print("Setting dropoff location: \(nav.userStartingLocation.debugDescription)")
                    builder = builder.setDropoffLocation(nav.userStartingLocation!)
                }
                
                
                //Prefill uber product for user's budget rating
                if nav.uberProductID != nil {
                    builder = builder.setProductID(nav.uberProductID!)
                }
                
                //Create Uber button
                print("Creating uber button")
                let uberButton = RideRequestButton(rideParameters: builder.build(), requestingBehavior: behavior)
                uberButton.setTitle("Ride back home", forState: .Normal)
                uberButton.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(uberButton)
                ConfirmScheduleViewController.setConstraintsForSubmitButton(uberButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
                
            } else {
                pickupDetails.text = "\(nav.bizDriveETA) minute drive to \(nav.bizName)"
            }
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
