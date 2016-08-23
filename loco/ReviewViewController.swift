//
//  ReviewViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/6/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Cosmos
import Parse

class ReviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //MARK: Outlets
    @IBOutlet weak var ratingQuestionPrompt: UILabel!
    @IBOutlet weak var cosmosStars: CosmosView!
    @IBOutlet weak var favoriteDish: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Mark: Properties
    var restaurant: Restaurant!
    var merchantTagsSelected = [String]()
    var reviewRating: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingQuestionPrompt.text = "How did you enjoy your experience at \(restaurant.name)?"
        
        cosmosStars.didFinishTouchingCosmos = { (rating) in
            print("User rated a rating of \(rating)")
            self.reviewRating = rating
        }
        
        comments.layer.borderWidth = 1
        comments.layer.borderColor = UIColor.grayColor().CGColor
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)

    }

    @IBAction func tagSelected(sender: UIButton) {
        if !sender.selected {
            merchantTagsSelected.append(sender.currentTitle!)
            sender.selected = true
        } else if let tagIndex = merchantTagsSelected.indexOf(sender.currentTitle!) {
            merchantTagsSelected.removeAtIndex(tagIndex)
            sender.selected = false
        } else {
            print("Error processing merchant tags")
        }

    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: UITextViewDelegate
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }

    
    @IBAction func submitReview() {
        guard let currentUser = PFUser.currentUser() where currentUser.email != nil else {
            print("Error: user is not logged in yet attempting to save review")
            return
        }
        
        guard reviewRating != nil else {
            let alert = UIAlertController(title: "Whoops!", message: "Please rate your experience", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let review = PFObject(className: "Review")
        review["user_id"] = currentUser["fb_id"]
        review["merchant_name"] = restaurant.name
        review["merchant_permalink"] = restaurant.reservation.yelpPermalink
        review["merchant_image_URL"] = restaurant.imageURL
        review["reservation_date"] = restaurant.reservation.reservationDate
        review["rating"] = reviewRating
        review["tags"] = merchantTagsSelected
        review["favorite_dish"] = favoriteDish.text
        review["comments"] = comments.text
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        review.saveInBackgroundWithBlock { (success, error) in
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error != nil {
                print("Error saving user review to Parse \(error)")
            } else {
                print("Successfully saved user review to Parse")
                self.performSegueWithIdentifier("showReviewConfirmation", sender: self)
            }
            
          
            

        }
        
        
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
