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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        print("finished view did load")
        
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

