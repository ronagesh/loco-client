//
//  ConfirmScheduleViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/21/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation
import UberRides
import Alamofire
import SwiftyJSON
import Parse

class ConfirmScheduleViewController: UIViewController, RideRequestViewControllerDelegate, ModalViewControllerDelegate, RideRequestButtonDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var merchantDriveETA: UILabel!
    
    @IBOutlet weak var pickupDetails: UILabel!
    @IBOutlet weak var reservationDetails: UILabel!
    
    @IBOutlet weak var driveMode: UISegmentedControl!
    
    
    //MARK: Properties
    var restaurant: Restaurant!
    
    var userCurrentLocation: CLLocation?
    
    var uberProductID: String?
    //var uberButton: RideRequestButton!
    var uberButton: UIButton!
    var driveOnOwnButton: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    
    let geocoder = CLGeocoder()
    var behavior: RideRequestViewRequestingBehavior!
    
    let CONFIRM_RESERVATION_REQUEST_URL = "http://127.0.0.1:5000/api/v1/reservations.json"
    let DEFAULT_PARTY_SIZE = 2 //hardcode party size of 2 for now
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uberProductID = NSUserDefaults.standardUserDefaults().objectForKey("uberProductID") as? String

        merchantName.text = restaurant.name
        if restaurant.neighborhood != "" {
            merchantAddress.text = restaurant.neighborhood
        } else {
            merchantAddress.text = restaurant.address
        }
        
        merchantDriveETA.text = "\(restaurant.reservation.driveTime / 60) min. drive away"
        reservationDetails.text = "\(restaurant.reservation.formatReservationTimeString()) Reservation at \(restaurant.name)"
        pickupDetails.text = "\(restaurant.reservation.getUberPickupTimeFormattedString()) Uber pickup"
        
        
        print("In confirm schedule VC view did load")
        
        
        //Render uber button with user's current location if authorized
        
        // Pass in a UIViewController to modally present the Uber Ride Request Widget over
        var builder = RideParametersBuilder()
        behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
        behavior.modalRideRequestViewController.rideRequestViewController.delegate = self
        behavior.modalRideRequestViewController.delegate = self
        
        //Prefill destination for Uber
        if restaurant.geocodedAddress != nil {
            print("Setting dropoff location: \(restaurant.geocodedAddress.debugDescription)")
            builder = builder.setDropoffLocation(restaurant.geocodedAddress!, address: restaurant.address)
        }
        
        //Prefill current location and type of Uber
        if userCurrentLocation != nil {
            print("Pickup location: \(userCurrentLocation.debugDescription)")
            builder = builder.setPickupLocation(userCurrentLocation!)
        }
        
        //Prefill uber product for user's budget rating
        if uberProductID != nil {
            print("Setting uber product ID: \(uberProductID) ")
            builder = builder.setProductID(uberProductID!)
        }
        
        //Create Uber button
        print("Creating uber button")
        //uberButton = RideRequestButton(rideParameters: builder.build(), requestingBehavior: behavior)
        uberButton = UIButton(type: UIButtonType.System)
        uberButton.setTitle("Ride there with Uber", forState: .Normal)
        uberButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        uberButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        uberButton.backgroundColor = UIColor.blackColor()

        //uberButton.delegate = self
        uberButton.translatesAutoresizingMaskIntoConstraints = false
        uberButton.addTarget(self, action: #selector(makeReservation), forControlEvents: .TouchUpInside)
        self.view.addSubview(uberButton)
        ConfirmScheduleViewController.setConstraintsForSubmitButton(uberButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
        
        //Create Confirm button for drive on own case
        driveOnOwnButton = UIButton(type: UIButtonType.System)
        driveOnOwnButton.setTitle("Confirm", forState: .Normal)
        driveOnOwnButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        driveOnOwnButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        driveOnOwnButton.backgroundColor = UIColor.blackColor()
        driveOnOwnButton.translatesAutoresizingMaskIntoConstraints = false
        driveOnOwnButton.addTarget(self, action: #selector(makeReservation), forControlEvents: .TouchUpInside)
        
        //Code to hide back button on uber widget
        //behavior.modalRideRequestViewController.rideRequestViewController.navigationItem.setLeftBarButtonItem(nil, animated: true)
        
        //Custom back button for Uber widget
        /*
        behavior.modalRideRequestViewController.rideRequestViewController.navigationItem.setLeftBarButtonItem(nil, animated: true)
        let bundle = NSBundle(forClass: RideRequestButton.self)
        let backImage =  UIImage(named: "ic_back_arrow_white", inBundle: bundle, compatibleWithTraitCollection: nil)
        let backButton = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: #selector(uberWidgetBackPressed))
        backButton.tintColor = UIColor.whiteColor()
        behavior.modalRideRequestViewController.rideRequestViewController.navigationItem.setLeftBarButtonItem(backButton, animated: true) //point to custom back button for uber widget

        */
        
        /*
        var loopExit = false
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
           
            while !loopExit {
                delay(5.0, closure: { 
                    ridesClient.fetchCurrentRide { (ride, response) in
                        guard response.error != nil && ride?.status != nil else {
                            print("Error fetching current ride and its status")
                            return
                        }
                        
                        switch ride!.status! {
                        case .InProgress:
                            loopExit = true
                            print("Ride is in progress. Break out of loop")
                            dispatch_async(dispatch_get_main_queue(), {
                                behavior.modalRideRequestViewController.rideRequestViewController.navigationItem.setLeftBarButtonItem(nil, animated: true)
                            })
                            break
                        case .Unknown, .RiderCanceled, .NoDriversAvailable, .DriverCanceled:
                            loopExit = false
                            print("Ride status: \(ride!.status!)")
                            dispatch_async(dispatch_get_main_queue(), {
                                if behavior.modalRideRequestViewController.rideRequestViewController.navigationItem.leftBarButtonItem == nil {
                                    behavior.modalRideRequestViewController.colorStyle = .Default
                                }
                            })
                            break
                        default:
                            loopExit = false
                            print("Ride status: \(ride!.status!)")
                            dispatch_async(dispatch_get_main_queue(), {
                                behavior.modalRideRequestViewController.rideRequestViewController.navigationItem.setLeftBarButtonItem(nil, animated: true)
                            })
                            break
                        }
                    }
                })
              
            }
        } */
    }
    
    /*
    func uberWidgetBackPressed() {
        let ridesClient = RidesClient()
        ridesClient.fetchCurrentRide { (ride, response) in
            if response.error != nil {
                self.behavior.modalRideRequestViewController.dismiss()
                return
            }
            
            switch ride!.status! {
            case .Completed:
                self.performSegueWithIdentifier("confirmScheduleToReceipt", sender: self)
            case .Accepted, .InProgress, .Arriving, .Processing:
                let alert = UIAlertController(title: "Whoops!", message: "Your Uber ride is in progress", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                break
            default:
                self.behavior.modalRideRequestViewController.dismiss()
                break
            }
        }

    } */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Update schedule to toggle between rideshare and drive on own modes
    @IBAction func driveModeChanged() {
        
        //Uber case
        if driveMode.selectedSegmentIndex == 0 {
            driveOnOwnButton.removeFromSuperview()
            self.view.addSubview(uberButton)
           ConfirmScheduleViewController.setConstraintsForSubmitButton(uberButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
            pickupDetails.text = "\(restaurant.reservation.getUberPickupTimeFormattedString()) Uber pickup"
        } else { //drive on own case
            uberButton.removeFromSuperview()
            self.view.addSubview(driveOnOwnButton)
           ConfirmScheduleViewController.setConstraintsForSubmitButton(driveOnOwnButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
            pickupDetails.text = "\(restaurant.reservation.driveTime / 60) minute drive to \(restaurant.name)"
        }
    }
    
    func makeReservation() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        
        
        guard let currentUser = PFUser.currentUser() where currentUser.email != nil else {
            print("ERROR: User is null. Cannot make reservation")
            return
        }
        
        var reservationParameters = [String:String]()
        reservationParameters["rezDate"] = restaurant.reservation.reservationDate
        reservationParameters["rezTime"] = restaurant.reservation.reservationTime
        reservationParameters["bizId"] = restaurant.reservation.yelpBizID
        reservationParameters["permalink"] = restaurant.reservation.yelpPermalink
        reservationParameters["partySize"] = String(DEFAULT_PARTY_SIZE)
        reservationParameters["firstName"] = currentUser["first_name"] as? String
        reservationParameters["lastName"] = currentUser["last_name"] as? String
        reservationParameters["email"] = currentUser.email
        reservationParameters["phone"] = currentUser["phone"] as? String
        
        Alamofire.request(.POST, CONFIRM_RESERVATION_REQUEST_URL, parameters: reservationParameters, encoding: .URL, headers: nil)
                .validate()
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        self.restaurant.reservation.cancellationURL = json["cancellation_url"].stringValue
                        
                        if self.driveMode.selectedSegmentIndex == 1 {
                            self.performSegueWithIdentifier("confirmScheduleToReceipt", sender: self)
                        } else {
                            self.performSegueWithIdentifier("confirmScheduleToUber", sender: self)
                        }
                    }
                    break
                case .Failure(let error):
                    print(error)
                    break
                }
 
            }
    }

    
    static func setConstraintsForSubmitButton(button: UIButton, view: UIView, bottomGuide: UILayoutSupport) {
        
        let heightConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 50)
        
        let leadingConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: bottomGuide,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: -20)
        
        NSLayoutConstraint.activateConstraints([heightConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
    }
    
    //MARK: RideRequestViewControllerDelegate
    func rideRequestViewController(rideRequestViewController: RideRequestViewController, didReceiveError error: NSError) {
        let errorType = RideRequestViewErrorType(rawValue: error.code) ?? .Unknown
        // Handle error here
        switch errorType {
        case .AccessTokenMissing:
            print("Access token missing")
            break
        // No AccessToken saved
        case .AccessTokenExpired:
            print("Uber access token expired")
            break
        // AccessToken expired / invalid
        case .NetworkError:
            print("uber network error")
            break
        default:
            print("unknown uber error")
            break
            
        }
    }
    
    //MARK: ModalViewControllerDelegate
    
    func modalViewControllerWillDismiss(modalViewController: ModalViewController) {
        self.performSegueWithIdentifier("confirmScheduleToReceipt", sender: self)
    }
    
    func modalViewControllerDidDismiss(modalViewController: ModalViewController) {  
    }
    
    //MARK: RideRequestButtonDelegate
    func rideRequestButtonDidLoadRideInformation(button: RideRequestButton) {
        print("Uber button loaded ride info")
    }
    
    
    func rideRequestButtonWasTapped(button: RideRequestButton) {
        print("Uber button was tapped")
    }
    
    func rideRequestButton(button: RideRequestButton, didReceiveError error: RidesError) {
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "confirmScheduleToReceipt" {
                if let vc = segue.destinationViewController as? ReceiptPageViewController {
                    vc.restaurant = restaurant
                    vc.userStartingLocation = userCurrentLocation
                    vc.transportationMode = driveMode.selectedSegmentIndex
                    vc.uberProductID = uberProductID
                }
            } else if identifier == "confirmScheduleToUber" {
                if let vc = segue.destinationViewController as? EmbeddedUberViewController {
                    vc.restaurant = restaurant
                    vc.userStartingLocation = userCurrentLocation
                    vc.transportationMode = driveMode.selectedSegmentIndex
                    vc.uberProductID = uberProductID
                    
                }
            }
        }
    }

}


