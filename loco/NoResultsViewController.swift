//
//  NoResultsViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/21/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class NoResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func editPreferences() {
        if CLLocationManager.authorizationStatus() == .Denied {
            self.performSegueWithIdentifier("editLocation", sender: self)
        } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.performSegueWithIdentifier("editCuisinePreferences", sender: self)
        }

    }
    
}
