//
//  RecommendationsContentViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class RecommendationsContentViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var merchantImage: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantCuisine: UILabel!
    @IBOutlet weak var merchantAddress: UILabel!
    @IBOutlet weak var merchantDriveETA: UILabel!
    @IBOutlet weak var merchantBudgetRating: UILabel!
    @IBOutlet weak var merchantBlurb: UILabel!
    
    
    //MARK: Properties
    var restaurant: Restaurant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchantImage.image = UIImage(named: restaurant.imageURL)
        merchantName.text = restaurant.name
        merchantCuisine.text = restaurant.cuisineType.rawValue
        merchantAddress.text = restaurant.address
        merchantDriveETA.text = "\(restaurant.getRideTime()) min. drive away"
        merchantBudgetRating.text = restaurant.budgetRating.rawValue
        merchantBlurb.text = restaurant.blurb

    }
    
    
    @IBAction func goTapped() {
        print("Let's go button tapped")
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
