//
//  WelcomeViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var initialAuthStatus = CLLocationManager.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "loco_logo")
        let logoView = UIImageView(image: logo)
        self.navigationItem.titleView = logoView

        //Prompt user to share location with app if they haven't already
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        initialAuthStatus = CLLocationManager.authorizationStatus()
        
        /*
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }*/
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        styleNavBar()
        styleTabBar()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedTapped() {
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .Denied:
            self.performSegueWithIdentifier("welcomeToLocation", sender: self)
            break
        case .AuthorizedWhenInUse:
            self.performSegueWithIdentifier("welcomeToCuisine", sender: self)
            break
        default:
            print("Unknown location authorization state for user")
            break
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status != initialAuthStatus {
            switch status {
            case .Denied:
                //Prompt user to manually enter home city
                print("User denied lcoation usage for app")
                self.performSegueWithIdentifier("welcomeToLocation", sender: self)
                break
            case .AuthorizedWhenInUse:
                print("User authorized location usage for app")
                self.performSegueWithIdentifier("welcomeToCuisine", sender: self)
                break
            default:
                print("Unknown location authorization state for user")
                break
            }
        }
    }
    
    private func styleNavBar() {
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 38, green: 34, blue: 23)
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    private func styleTabBar() {
        self.tabBarController?.tabBar.hidden = true
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
