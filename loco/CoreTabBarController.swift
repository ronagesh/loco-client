//
//  CoreTabBarController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/23/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import CoreLocation

class CoreTabBarController: UITabBarController {

    var userCurrentLocation: CLLocation?
    var uberProductID: String?
    var restaurants: [Restaurant]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
