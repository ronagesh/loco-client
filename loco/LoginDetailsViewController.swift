//
//  LoginDetailsViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/26/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse

class LoginDetailsViewController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    //MARK: Properties
    var restaurant: Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        phoneField.delegate = self
       
        if let userEmail = PFUser.currentUser()?.email {
            emailField.text = userEmail
        }
        
        if let userPhone = PFUser.currentUser()?["phone"] as? String {
            phoneField.text = userPhone
        }
        
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //User just finished email field
        if textField.tag == 0 {
            phoneField.becomeFirstResponder()
        } else {
            //User just finished phone field
            textField.resignFirstResponder()
            saveUserContactInfo()
        }
        
        return true
    }
    
    @IBAction func saveUserContactInfo() {
        guard let email = emailField.text where !emailField.text!.isEmpty else {
            let alert = UIAlertController(title: "Whoops!", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let phone = phoneField.text where !phoneField.text!.isEmpty else {
            let alert = UIAlertController(title: "Whoops!", message: "Please enter a valid phone number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        print("Saving email and phone number for user to Parse: \(email), \(phone)")
        
        if let currentUser = PFUser.currentUser() {
            currentUser.email = email
            currentUser["phone"] = phone
            currentUser.saveInBackgroundWithBlock({ (success, error) in
                if error != nil {
                    print("Error saving user's phone and email to Parse \(error)")
                } else {
                    print("Successfully saved user's phone and email to Parse with phone \(phone) and email \(email)")
                }
            })
        }
        
        self.performSegueWithIdentifier("userContactInfoToConfirmSchedule", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "userContactInfoToConfirmSchedule" {
                if let vc = segue.destinationViewController as? ConfirmScheduleViewController {
                    vc.restaurant = restaurant
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
