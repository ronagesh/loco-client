//
//  LoginViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/25/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4


class LoginViewController: UIViewController {

    //MARK: Properties
    var bizName: String!
    var bizAddress: String!
    var bizDriveETA: Int!
    var resTimeDisplay: String!
    var dropoffLocation: CLLocation?
    var uberPickupTimeDisplay: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                    self.performSegueWithIdentifier("loginToUserContactInfo", sender: self)
                                }
                            }
                        }
                    }
                    
                } else {
                    print("User already exists and logged in through Facebook!")
                    self.performSegueWithIdentifier("loginToConfirmSchedule", sender: self)
                    
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }

    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "loginToConfirmSchedule" {
                if let vc = segue.destinationViewController as? ConfirmScheduleViewController {
                    vc.bizName = bizName
                    vc.bizAddress = bizAddress
                    vc.bizDriveETA = bizDriveETA
                    vc.resTimeDisplay = resTimeDisplay
                    vc.dropoffLocation = dropoffLocation
                    vc.uberPickupTimeDisplay = uberPickupTimeDisplay
                }
            } else if identifier == "loginToUserContactInfo" {
                if let vc = segue.destinationViewController as? LoginDetailsViewController {
                    vc.bizName = bizName
                    vc.bizAddress = bizAddress
                    vc.bizDriveETA = bizDriveETA
                    vc.resTimeDisplay = resTimeDisplay
                    vc.dropoffLocation = dropoffLocation
                    vc.uberPickupTimeDisplay = uberPickupTimeDisplay
                }
                
            }
        }
    }

}
