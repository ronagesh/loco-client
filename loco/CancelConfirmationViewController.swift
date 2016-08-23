//
//  CancelConfirmationViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/20/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class CancelConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delay(3) {
            self.performSegueWithIdentifier("cancelToRecs", sender: self)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButtonTapped() {
        self.performSegueWithIdentifier("cancelToRecs", sender: self)
    }
}
