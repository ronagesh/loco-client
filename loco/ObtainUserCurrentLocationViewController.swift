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
import Alamofire
import SwiftyJSON


class ObtainUserCurrentLocationViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var userCurrentLocation: CLLocation?
    
    var restaurants = [Restaurant]()
    var activityIndicator = UIActivityIndicatorView()
    
    let DEFAULT_PARTY_SIZE = 2
    let MAX_RESULTS = 5
    let GET_RESTAURANTS_REQUEST_URL = "http://159.203.251.219:5000/api/v1/restaurants.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        //self.navigationController?.navigationBarHidden = true
        //self.navigationController?.navigationBar.hidden = true
        
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
        
        
        var parameters = [String:String]()
        parameters["startLatitude"] = userCurrentLocation!.coordinate.latitude.description
        parameters["startLongitude"] = userCurrentLocation!.coordinate.longitude.description
        
        //Fetch cuisine preferences from client store
        if let userCuisinePreferences = NSUserDefaults.standardUserDefaults().objectForKey("userCuisinePreferences") as? [String] {
            let cuisineString = userCuisinePreferences.joinWithSeparator(",")
            parameters["cuisinePrefs"] = cuisineString
        }
        
        //Fetch budget preferences from client store
        if let userBudgetPreferences = NSUserDefaults.standardUserDefaults().objectForKey("userBudgetPreferences") as? String {
            let budgetString = locoAPIBudgetMap[userBudgetPreferences]!
            parameters["budgetScale"] = budgetString
            
            //Async fetch Uber Product ID
            if let uberProductID = NSUserDefaults.standardUserDefaults().objectForKey("uberProductID") as? String {
                parameters["uberProductID"] = uberProductID
            } else {
                fetchUberProductID(userCurrentLocation!, budgetRating: userBudgetPreferences)
            }
        }

        parameters["isVegetarian"] = "false"
        parameters["partySize"] = String(DEFAULT_PARTY_SIZE)
        
        Alamofire.request(.GET, GET_RESTAURANTS_REQUEST_URL, parameters: parameters, encoding: .URL)
            .validate()
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        
                        guard json.count > 0 else {
                            print("No results to show user")
                            self.performSegueWithIdentifier("noResults", sender: self)
                            return
                        }
                        
                        for result in json.arrayValue {
                            //Populate restaurant parameters
                            let businessName = result["business_name"].stringValue
                            
                            //Async fetch merchant image
                            var profileImageURL = ""
                            if result["profile_image_google"] != "" {
                                profileImageURL = result["profile_image_google"].stringValue
                            } else {
                                profileImageURL = result["profile_image_yelp"].stringValue
                            }
                            
                            let cuisine = result["cuisine"].stringValue
                            let address = result["address"].stringValue
                            let neighborhood = result["neighborhood"].stringValue
                            let budgetRating = result["budget_rating"].stringValue
                            
                            //Populate reservation parameters
                            let yelpBizID = result["biz_id"].stringValue
                            let yelpPermalink = result["permalink"].stringValue
                            let reservationDate = result["current_date"].stringValue
                            let reservationTime = result["first_compatible_timeslot"].stringValue
                            let partySize = self.DEFAULT_PARTY_SIZE
                            let uberHailTime = result["uber_hail_time"].int
                            let driveTime = result["drive_time"].int
                            let totalTripTime = result["total_trip_time"].int
                            
                            let reservation = Reservation(yelpBizID: yelpBizID, yelpPermalink: yelpPermalink, reservationDate: reservationDate, reservationTime: reservationTime, partySize: partySize, uberHailTime: uberHailTime!, driveTime: driveTime!, totalTripTime: totalTripTime!)
                            
                            let restaurant = Restaurant(name: businessName, imageURL: profileImageURL, cuisineType: RestaurantCuisines(rawValue: cuisine)!, address: address, neighborhood: neighborhood, budgetRating: locoYelpBudgetMap[budgetRating]!, reservation: reservation)
                            
                            self.restaurants.append(restaurant)
                            if self.restaurants.count == self.MAX_RESULTS {
                                break
                            }
    
                        }
                        self.performSegueWithIdentifier("networkCallStallingToRecs", sender: self)
                     
                    }
                    break
                case .Failure(let error):
                    print(error)
                    print("Server error: No results to show user")
                    self.performSegueWithIdentifier("noResults", sender: self)
                    break
                }  
               
        }
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
