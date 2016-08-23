//
//  CoreTabBarController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/22/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class CoreTabBarController: UITabBarController {

    var userCurrentLocation: CLLocation?
    var restaurants: [Restaurant]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
