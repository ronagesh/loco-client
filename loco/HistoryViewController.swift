//
//  HistoryViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/20/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse
import Cosmos
import Kingfisher

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: Properties
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.tableFooterView = UIView(frame: CGRectZero)
        self.automaticallyAdjustsScrollViewInsets = false
           
        //Perform Parse query to fetch number of prior trips for user
        guard let currentUser = PFUser.currentUser() where currentUser.email != nil else {
            print("Error: No logged in user to fetch history for")
            return
        }
        
        let query = PFQuery(className: "Review")
        query.whereKey("user_id", equalTo: currentUser["fb_id"])
        query.orderByDescending("createdAt")
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        query.findObjectsInBackgroundWithBlock { (objects, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            guard error == nil else {
                print("Error fetching history for user")
                return
            }
            
            print("Successfully fetched history for user")
            if objects != nil {
                for object in objects! {
                    let merchantImageURL = object["merchant_image_URL"] as! String
                    let merchantName = object["merchant_name"] as! String
                    let reservationDate = object["reservation_date"] as! String
                    let rating = object["rating"] as! Double
                    
                    let review = Review(merchantImageURL: merchantImageURL, merchantName: merchantName, reservationDate: reservationDate, rating: rating)
                    self.reviews.append(review)
                    self.historyTableView.reloadData()
                }
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    /*
    override func viewDidLayoutSubviews() {
        historyTableView.separatorInset = UIEdgeInsetsZero
        historyTableView.layoutMargins = UIEdgeInsetsZero
    } */
    
    //MARK: Table View DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        historyTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    /*
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }*/

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        let review = reviews[indexPath.row]
        cell.merchantImage.kf_setImageWithURL(NSURL(string: review.merchantImageURL))
        cell.merchantImage.kf_showIndicatorWhenLoading = true
        cell.merchantName.text = review.merchantName
        cell.reservationDate.text = review.reservationDate
        cell.rating.rating = review.rating
        cell.rating.settings.updateOnTouch = false
        
        return cell
        
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
