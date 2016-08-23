//
//  CuisinePreferencesViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/12/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class CuisinePreferencesViewController: UIViewController {

    var cuisinesSelected = [String]()

    //maps cuisine string to storyboard tag to identify corresponding button
    let cuisineChoices = [
        "American": 1,
        "Chinese": 2,
        "French": 3,
        "Indian": 4,
        "Italian": 5,
        "Japanese": 6,
        "Mediterranean": 7,
        "Mexican": 8,
        "Thai": 9,
        "Vegetarian": 10,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = false

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
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
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
