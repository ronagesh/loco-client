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
import Alamofire

class ReceiptPageViewController: UIViewController, ModalViewControllerDelegate {

    //MARK: Outlets
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var merchantDriveETA: UILabel!

    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var pickupDetails: UILabel!
    @IBOutlet weak var reservationDetails: UILabel!
    
    //MARK: Properties
    var restaurant: Restaurant!
    var transportationMode: Int!
    var userStartingLocation: CLLocation?
    var uberProductID: String?
    
    let CANCEL_RESERVATION_REQUEST_URL = "http://159.203.251.219:5000/api/v1/reservation_cancellations.json"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    
        merchantName.text = restaurant.name
        merchantAddress.text = restaurant.address
        merchantDriveETA.text = "\(restaurant.reservation.driveTime / 60) min. drive away"
        reservationDetails.text = "\(restaurant.reservation.formatReservationTimeString()) Reservation at \(restaurant.name)"
        greeting.text = "Enjoy your date night \(PFUser.currentUser()!["first_name"]!). Go loco!"
        
        if transportationMode == 0 {
            pickupDetails.text = "\(restaurant.reservation.getUberPickupTimeFormattedString()) Uber pickup"
            
            // Pass in a UIViewController to modally present the Uber Ride Request Widget over
            var builder = RideParametersBuilder()
            let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
            behavior.modalRideRequestViewController.delegate = self
            
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
            pickupDetails.text = "\(restaurant.reservation.driveTime / 60) minute drive to \(restaurant.name)"
        }
        
        //2 hour delay to prompt user to fill out review
        delay(7200) {
            self.performSegueWithIdentifier("thankYouToReview", sender: self)
        }

    }
    
    @IBAction func cancelReservation(sender: UIBarButtonItem) {
    
        guard let currentUser = PFUser.currentUser() where currentUser.email != nil else {
            print("ERROR: User is null. Cannot cancel reservation")
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var cancelParameters = [String:String]()
        cancelParameters["cancellationUrl"] = restaurant.reservation.cancellationURL
        
        //Execute cancel POST request
        Alamofire.request(.POST, CANCEL_RESERVATION_REQUEST_URL, parameters: cancelParameters, encoding: .URL, headers: nil)
            .validate()
            .response { request, response, data, error in
                activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error != nil {
                    print(error)
                    print("Error cancelling reservation")
                } else {
                    print("Successfully cancelled reservation")
                    self.performSegueWithIdentifier("showCancelConfirmation", sender: self)
                    
                }
        }
    }
    
    //MARK: ModalViewControllerDelegate
    
    func modalViewControllerWillDismiss(modalViewController: ModalViewController) {
        self.performSegueWithIdentifier("thankYouToReview", sender: self)
    }
    
    func modalViewControllerDidDismiss(modalViewController: ModalViewController) {
    }


    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "thankYouToReview" {
                if let vc = segue.destinationViewController as? ReviewViewController {
                    vc.restaurant = restaurant
                }
            }
        }
    }
}
