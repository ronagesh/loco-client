//
//  CuisinePreferencesViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/12/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class CuisinePreferencesViewController: UIViewController {

    var cuisinesSelected = [String]()
    let locationManager = CLLocationManager()

    //maps cuisine string to storyboard tag to identify corresponding button
    let cuisineChoices = [
        "American": 0,
        "Chinese": 1,
        "French": 2,
        "Indian": 3,
        "Italian": 4,
        "Japanese": 5,
        "Mediterranean": 6,
        "Mexican": 7,
        "Thai": 8,
        "Vegetarian": 9,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        //Pull in already saved cuisine preferences
        if let userCuisinePreferences = NSUserDefaults.standardUserDefaults().objectForKey("userCuisinePreferences") as? [String] {
            for cuisine in userCuisinePreferences {
                cuisinesSelected.append(cuisine)
                let buttonTag = cuisineChoices[cuisine]!
                if let button = self.view.viewWithTag(buttonTag) as? UIButton {
                    button.selected = true
                }
            }
        }
    }
    
    //Custom logic to skip to appropriate view controller if user hits back button
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //User hit back button
        if self.isMovingFromParentViewController() {
            if CLLocationManager.authorizationStatus() == .Denied {
                self.performSegueWithIdentifier("unwindCuisineToLocation", sender: self)
            } else {
                self.performSegueWithIdentifier("unwindCuisineToWelcome", sender: self)
            }
            
            
            
            
            
            /*
            var deniedTargetVC = UIViewController()
            var authorizedTargetVC = UIViewController()
            
            if let navStack = self.navigationController?.viewControllers {
                for vc in navStack {
                    if vc.isKindOfClass(ManualLocationViewController) {
                        deniedTargetVC = vc
                    } else if vc.isKindOfClass(WelcomeViewController) {
                        authorizedTargetVC = vc
                    }
                }
            }
            
            switch CLLocationManager.authorizationStatus() {
            case .Denied:
                print(self.navigationController?.popToViewController(deniedTargetVC, animated: true))
                break
            case .AuthorizedWhenInUse:
                print(self.navigationController?.popToViewController(authorizedTargetVC, animated: false))
                break
            default:
                print("Unknown location authorization state for user")
                break
            }
        */
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCuisine(sender: UIButton) {
        if !sender.selected {
            cuisinesSelected.append(sender.currentTitle!)
            sender.selected = true
        } else if let cuisineIndex = cuisinesSelected.indexOf(sender.currentTitle!) {
            cuisinesSelected.removeAtIndex(cuisineIndex)
            sender.selected = false
        } else {
            print("Cuisine was supposed to be in user's preferences but wasn't")
        }
        print("cuinsines array: \(cuisinesSelected)")
    }
    
    
    @IBAction func submitPreferences() {
        if cuisinesSelected.count == 0 {
            let alert = UIAlertController(title: "Whoops!", message: "Please select at least one cuisine.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            print("Saving cuisine preferences array: \(cuisinesSelected)")
            NSUserDefaults.standardUserDefaults().setObject(cuisinesSelected, forKey: "userCuisinePreferences")
            self.performSegueWithIdentifier("cuisineToBudgetPreferences", sender: self)
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
