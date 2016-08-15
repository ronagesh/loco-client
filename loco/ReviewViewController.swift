//
//  ReviewViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/6/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var ratingQuestionPrompt: UILabel!
    @IBOutlet weak var cosmosStars: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosStars.didFinishTouchingCosmos = { (rating) in
            print("User rated a rating of \(rating)")
        }
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
