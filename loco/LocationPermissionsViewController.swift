//
//  LocationPermissionsViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/15/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionsViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prompt user to share location with app if they haven't already
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("Initial authorization status: \(CLLocationManager.authorizationStatus().rawValue)")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .Denied:
            //Prompt user to manually enter home city
            print("User denied lcoation usage for app")
            self.performSegueWithIdentifier("locationPermissionsToManualLocation", sender: self)
            break
        case .AuthorizedWhenInUse:
            print("User authorized location usage for app")
            self.performSegueWithIdentifier("locationToCuisinePreferences", sender: self)
            break
        default:
            print("Unknown location authorization state for user")
            break
        }
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
