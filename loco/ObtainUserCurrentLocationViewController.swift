//
//  ObtainUserCurrentLocationViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/23/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation
import UberRides


class ObtainUserCurrentLocationViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var userCurrentLocation: CLLocation?
    
    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true

        //print("In ObtainUserCurrentLocation VC view did load")
        
        //TODO: Call backend to fetch list of restaurants to recommend to user
        
        //Hardcoded Restaurants for now
        let rest1 = Restaurant(name: "Rangoon Ruby", imageURL: "rangoon_ruby", cuisineType: RestaurantCuisines.Thai, address: "445 Emerson Street, Palo Alto, CA 94031", budgetRating: RestaurantBudgetRatings.Smart, blurb: "Relaxed Burmese restaurant with contemporary decor, a trendy bar & exotic tiki cocktails.")
        
        let rest2 = Restaurant(name: "La Viga Restaurant", imageURL: "la_viga", cuisineType: RestaurantCuisines.Mexican, address: "1772 Broadway Street, Redwood City, CA 94063", budgetRating: RestaurantBudgetRatings.Smart, blurb: "Cozy Latin eatery features classic seafood dishes & comfort eats in a warm space with a casual vibe.")
        
        let rest3 = Restaurant(name: "Osteria", imageURL: "osteria", cuisineType: RestaurantCuisines.Italian, address: "247 Hamilton Ave Palo Alto, CA 94301", budgetRating: RestaurantBudgetRatings.Smart, blurb: "This Italian kitchen offers Tuscan fare in a simply appointed corner space with white linens.")
        
        restaurants.append(rest1)
        restaurants.append(rest2)
        restaurants.append(rest3)

        
        //Fetch user's current location if authorized
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userCurrentLocation != nil {
            return
        }
        userCurrentLocation = locations[0]
        print("User's current location fetched \(userCurrentLocation.debugDescription)")
        locationManager.stopUpdatingLocation()
        
        self.performSegueWithIdentifier("networkCallStallingToRecs", sender: self)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error fetching location for user \(error)")
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "networkCallStallingToRecs" {
                if let vc = segue.destinationViewController as? CoreTabBarController {
                    vc.userCurrentLocation = userCurrentLocation
                    vc.restaurants = restaurants
                }
            }
        }
    }
}
