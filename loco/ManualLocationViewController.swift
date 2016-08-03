//
//  ManualLocationViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/15/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class ManualLocationViewController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityText.delegate = self
        stateText.delegate = self
        
        if let userHomeCity = NSUserDefaults.standardUserDefaults().objectForKey("userHomeCity") as? String {
            cityText.text = userHomeCity
        }
        
        if let userHomeState = NSUserDefaults.standardUserDefaults().objectForKey("userHomeState") as? String {
            stateText.text = userHomeState
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //User just finished city field
        if textField.tag == 0 {
            stateText.becomeFirstResponder()
        } else {
            //User just finished state field
            textField.resignFirstResponder()
            submitManualLocation()
        }
        
        return true
    }

    @IBAction func submitManualLocation() {
        guard let city = cityText.text where !cityText.text!.isEmpty else {
            let alert = UIAlertController(title: "Whoops!", message: "Please enter a valid city", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let state = stateText.text where !stateText.text!.isEmpty else {
            let alert = UIAlertController(title: "Whoops!", message: "Please enter a valid state", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        print("Saving manually entered location: \(city), \(state)")
        NSUserDefaults.standardUserDefaults().setObject(city, forKey: "userHomeCity")
        NSUserDefaults.standardUserDefaults().setObject(state, forKey: "userHomeState")

        self.performSegueWithIdentifier("manualLocationToCuisine", sender: self)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
