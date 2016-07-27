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

        //print("In ObtainUserCurrentLocation VC view did load")
        
        //TODO: Call backend to fetch list of restaurants to recommend to user
        
        //Hardcoded Restaurants for now
        let rest1 = Restaurant(name: "Wayfare Tavern", imageURL: "wayfare_tavern", cuisineType: RestaurantCuisines.American, address: "558 Sacramento St, San Francisco, CA 94111 United States", budgetRating: RestaurantBudgetRatings.Luxe, blurb: "We picked this restaurant for its unique ambience and 4-star rating on Yelp.")
        
        let rest2 = Restaurant(name: "Zazie", imageURL: "zazie", cuisineType: RestaurantCuisines.French, address: "941 Cole St, San Francisco, CA 94117", budgetRating: RestaurantBudgetRatings.Upscale, blurb: "We picked this restaurant for its unique French offering and 4-star rating on Yelp.")
        
        let rest3 = Restaurant(name: "Skool", imageURL: "skool", cuisineType: RestaurantCuisines.American, address: "1725 Alameda St, San Francisco, CA 94103", budgetRating: RestaurantBudgetRatings.Upscale, blurb: "We picked this restaurant for its unique seafood offering and 4-star rating on Yelp.")
        
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
