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

class ConfirmScheduleViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var merchantDriveETA: UILabel!
    
    @IBOutlet weak var pickupDetails: UILabel!
    @IBOutlet weak var reservationDetails: UILabel!
    
    @IBOutlet weak var driveMode: UISegmentedControl!
    
    
    //MARK: Properties
    var bizName = ""
    var bizAddress = ""
    var bizDriveETA = 0
    var uberPickupTimeDisplay = ""
    var resTimeDisplay = ""
    
    var userCurrentLocation: CLLocation?
    var dropoffLocation: CLLocation?
    
    var uberProductID: String?
    var uberButton: RideRequestButton!
    var driveOnOwnButton: UIButton!
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarCont = self.tabBarController as? CoreTabBarController {
            userCurrentLocation = tabBarCont.userCurrentLocation
            uberProductID = tabBarCont.uberProductID
        }

        merchantName.text = bizName
        merchantAddress.text = bizAddress
        merchantDriveETA.text = "\(bizDriveETA) min. drive away"
        reservationDetails.text = "\(resTimeDisplay) Reservation at \(bizName)"
        pickupDetails.text = "\(uberPickupTimeDisplay) Uber pickup"
        
        print("In confirm schedule VC view did load")
        
        
        //Render uber button with user's current location if authorized
        
        // Pass in a UIViewController to modally present the Uber Ride Request Widget over
        var builder = RideParametersBuilder()
        let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)

        if dropoffLocation != nil {
            print("Setting dropoff location: \(dropoffLocation.debugDescription)")
            builder = builder.setDropoffLocation(dropoffLocation!)
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
        uberButton = RideRequestButton(rideParameters: builder.build(), requestingBehavior: behavior)
        uberButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uberButton)
        ConfirmScheduleViewController.setConstraintsForSubmitButton(uberButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
        
        //Create Confirm button for drive on own case
        driveOnOwnButton = UIButton(type: UIButtonType.System)
        driveOnOwnButton.setTitle("Confirm", forState: .Normal)
        driveOnOwnButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        driveOnOwnButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        driveOnOwnButton.backgroundColor = UIColor.blackColor()
        driveOnOwnButton.translatesAutoresizingMaskIntoConstraints = false
        driveOnOwnButton.addTarget(self, action: #selector(ConfirmScheduleViewController.showReceiptPage), forControlEvents: .TouchUpInside)
    }

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
            pickupDetails.text = "\(uberPickupTimeDisplay) Uber pickup"
        } else { //drive on own case
            uberButton.removeFromSuperview()
            self.view.addSubview(driveOnOwnButton)
           ConfirmScheduleViewController.setConstraintsForSubmitButton(driveOnOwnButton, view: self.view, bottomGuide: self.bottomLayoutGuide)
            pickupDetails.text = "\(bizDriveETA) minute drive to \(bizName)"
        }
    }
    
    func showReceiptPage() {
        self.performSegueWithIdentifier("confirmScheduleToReceipt", sender: self)
    }

    
    static func setConstraintsForSubmitButton(button: UIButton, view:UIView, bottomGuide: UILayoutSupport) {
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "confirmScheduleToReceipt" {
                if let vc = segue.destinationViewController as? ReceiptPageNavController {
                    vc.bizName = bizName
                    vc.bizAddress = bizAddress
                    vc.bizDriveETA = bizDriveETA
                    vc.resTimeDisplay = resTimeDisplay
                    vc.uberPickupTimeDisplay = uberPickupTimeDisplay
                    vc.userStartingLocation = userCurrentLocation
                    vc.transportationMode = driveMode.selectedSegmentIndex
                    vc.uberProductID = uberProductID
                }
            }
        }
    }
    

}
