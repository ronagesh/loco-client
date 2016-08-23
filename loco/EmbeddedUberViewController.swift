//
//  EmbeddedUberViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/17/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation
import UberRides

class EmbeddedUberViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    //MARK: Properties
    var restaurant: Restaurant!
    var userStartingLocation: CLLocation?
    var transportationMode: Int!
    var uberProductID: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.tabBarController?.tabBar.hidden = true
        
        var builder = RideParametersBuilder()
        
        //Prefill destination for Uber
        if self.restaurant.geocodedAddress != nil {
            print("Setting dropoff location: \(self.restaurant.geocodedAddress.debugDescription)")
            builder = builder.setDropoffLocation(self.restaurant.geocodedAddress!, address: self.restaurant.address)
        }
        
        //Prefill current location and type of Uber
        if self.userStartingLocation != nil {
            print("Pickup location: \(self.userStartingLocation.debugDescription)")
            builder = builder.setPickupLocation(self.userStartingLocation!)
        }
        
        //Prefill uber product for user's budget rating
        if self.uberProductID != nil {
            print("Setting uber product ID: \(self.uberProductID) ")
            builder = builder.setProductID(self.uberProductID!)
        }

        let navBarMaxY = self.navigationController!.navigationBar.frame.maxY
        let childFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - navBarMaxY)
        let rideRequestView = RideRequestView(rideParameters: builder.build(), frame: childFrame)
    
        self.view.addSubview(rideRequestView)
        
        if TokenManager.fetchToken()?.tokenString != nil {
            rideRequestView.load()
        } else {
            let loginManager = LoginManager()
            loginManager.login(requestedScopes:[.RideWidgets], presentingViewController: self, completion: { accessToken, error in
                guard accessToken != nil else {
                    print("Error fetching access token for user: \(error)")
                    return
                }
                
                rideRequestView.accessToken = accessToken
                rideRequestView.load()
                
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showReservationPopover(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showReservationPopover", sender: self)
    }
        
    @IBAction func finishUberWidget(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("uberToReceipt", sender: self)
    }

    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "uberToReceipt" {
                if let vc = segue.destinationViewController as? ReceiptPageViewController {
                    vc.restaurant = restaurant
                    vc.userStartingLocation = userStartingLocation
                    vc.transportationMode = transportationMode
                    vc.uberProductID = uberProductID
                }
            } else if identifier == "showReservationPopover" {
                if let vc = segue.destinationViewController as? ReservationPopoverViewController {
                    vc.preferredContentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 200)
                    vc.restaurant = restaurant
                    if let popoverVC = vc.popoverPresentationController {
                        popoverVC.delegate = self
                    }
                }
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
