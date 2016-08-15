 //
//  RecommendationsPageViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation
import UberRides
import Parse

class RecommendationsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: Model
    var restaurants = [Restaurant]()
    var userCurrentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tabBarCont = self.tabBarController as? CoreTabBarController else {
            print("Error obtaining tab bar controller to load restaurants")
            return
        }
        
        guard tabBarCont.restaurants?.count > 0 else {
            print("ERROR: Empty array of restaurants...nothing to show to user")
            return
        }
            
        restaurants = tabBarCont.restaurants!
        userCurrentLocation = tabBarCont.userCurrentLocation
        
        stylePageControl()
        dataSource = self
        self.view.backgroundColor = UIColor.whiteColor()
        
        let contentViewController = UIStoryboard(name: "Core", bundle: nil).instantiateViewControllerWithIdentifier("restaurantContentViewController") as! RecommendationsContentViewController
        
        if restaurants.count > 0 {
            contentViewController.restaurant = restaurants.first
        }
        
        /*
        //Async call #1: Refresh Uber access token if required
        if let token = ridesClient.fetchAccessToken() {
            if token.expirationDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending { //Access token is expired
                print("Access token expired for this old token: \(token.tokenString)")
                if let refreshToken = token.refreshToken {
                    ridesClient.refreshAccessToken(refreshToken) { (newAccessToken, response)  in
                        if response.error != nil {
                            print("Error refreshing Uber access token for user")
                        } else {
                            print("Successfully refreshed Uber access token for user. New access token: \(newAccessToken?.tokenString)")
                        }
                    }
                }
            }
        }*/
        
        //Async call #2: Geocode first restaurant's address if it hasn't already been
        if restaurants[0].geocodedAddress == nil {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(restaurants[0].address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else {
                    if let placemarksArr = placemarks {
                        self.restaurants[0].geocodedAddress = placemarksArr[0].location
                        print("Geocoded dropoff location for restaurant \(self.restaurants[0].name): \(self.restaurants[0].geocodedAddress.debugDescription)")
                    }
                }
            })
        }
        
        //Async call #3: Fetch user's FB profile picture for Profile tab
        if PFUser.currentUser()?.email != nil {
            ProfileViewController.fetchFBProfilePic()
        }
        setViewControllers([contentViewController], direction: .Forward, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let restaurantContentController = viewController as? RecommendationsContentViewController {
            
            //Lookup viewController's attached restaurant to get its index in the restaurants array in model
            guard let viewControllerIndex = restaurants.indexOf({
                $0.name == restaurantContentController.restaurant.name
            }) else {
                return nil
            }
            
            let prevIndex = viewControllerIndex - 1
            
            guard prevIndex >= 0 else {
                return nil
            }
            
            let prevViewController = UIStoryboard(name: "Core", bundle: nil).instantiateViewControllerWithIdentifier("restaurantContentViewController") as! RecommendationsContentViewController
            
            prevViewController.restaurant = restaurants[prevIndex]
            
            //Fire off async call to geocode prev restaurant's address if it hasn't already been
            let geocoder = CLGeocoder()
            if restaurants[prevIndex].geocodedAddress == nil {
                geocoder.geocodeAddressString(self.restaurants[prevIndex].address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        if let placemarksArr = placemarks {
                            self.restaurants[prevIndex].geocodedAddress = placemarksArr[0].location
                            print("Geocoded dropoff location for restaurant \(self.restaurants[prevIndex].name): \(self.restaurants[prevIndex].geocodedAddress.debugDescription)")
                        }
                    }
                })
            }
            
            return prevViewController
        }
        
        return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let restaurantContentController = viewController as? RecommendationsContentViewController {
            
            //Lookup viewController's attached restaurant to get its index in the restaurants array in model
            guard let viewControllerIndex = restaurants.indexOf({
                $0.name == restaurantContentController.restaurant?.name
            }) else {
                return nil
            }

            let nextIndex = viewControllerIndex + 1
            
            guard nextIndex < restaurants.count else {
                return nil
            }
            
            let nextViewController = UIStoryboard(name: "Core", bundle: nil).instantiateViewControllerWithIdentifier("restaurantContentViewController") as! RecommendationsContentViewController
            
            nextViewController.restaurant = restaurants[nextIndex]
            
            //Fire off async call to geocode next restaurant's address if it hasn't already been
            let geocoder = CLGeocoder()
            if restaurants[nextIndex].geocodedAddress == nil {
                geocoder.geocodeAddressString(self.restaurants[nextIndex].address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        if let placemarksArr = placemarks {
                            self.restaurants[nextIndex].geocodedAddress = placemarksArr[0].location
                            print("Geocoded dropoff location for restaurant \(self.restaurants[nextIndex].name): \(self.restaurants[nextIndex].geocodedAddress.debugDescription)")
                        }
                    }
                })
            }

            
            return nextViewController
            
        }
        
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return restaurants.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func stylePageControl() {
        let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([self.dynamicType])
        
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
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
