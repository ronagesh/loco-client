//
//  ViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 6/26/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation
import UberRides
import Parse
import ParseFacebookUtilsV4

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        */
        
        
        print("finished view did load")
        
    }
    
    @IBAction func fbLoginButtonPressed() {
    
        let requestedFBPermissions = ["public_profile", "email", "user_likes", "user_birthday", "user_relationships"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(requestedFBPermissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    
                    //Perform Graph requests to fetch FB user info
                    let requestParams = ["fields": "id, email, first_name, last_name, likes, significant_other, birthday"]
                    let fbGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: requestParams)
                    
                    fbGraphRequest.startWithCompletionHandler { (connection, result, error) in
                        
                        if error != nil {
                            print("Error fetching user info from Facebook")
                        } else if result != nil {
                            //Store user details to Parse cloud
                            user["fb_id"] = result["id"]!
                            user.email = result["email"]! as? String
                            user["first_name"] = result["first_name"]!
                            user["last_name"] = result["last_name"]!
                            //TODO: collect likes, significant_other, and birthday from Facebook and get approved for these permissions

                            user.saveInBackgroundWithBlock { (success, error) in
                                if error != nil {
                                    print("Error saving user info to Parse")
                                } else {
                                    print("Successfully saved user info to Parse")
                                }
                            }
                        }
                    }
                    
                } else {
                    print("User already exists and logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }

    
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        print("User's location is \(latitude) latitude and \(longitude) longitude")
        print("Location services enabled: \(CLLocationManager.locationServicesEnabled())")
        print("Location services authorized for app: \(CLLocationManager.authorizationStatus())")
        
        // Pass in a UIViewController to modally present the Uber Ride Request Widget over
        let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
        // Optional, defaults to using the user’s current location for pickup
        let parameters = RideParametersBuilder().setPickupLocation(userLocation).build()
        let button = RideRequestButton(rideParameters: parameters, requestingBehavior: behavior)
        self.view.addSubview(button)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
}

