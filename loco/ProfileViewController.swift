//
//  ProfileViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/16/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    
    //MARK: Properties
    let signUpButton = UIButton(type: UIButtonType.System)
    
    //MARK: Model
    let profileTableViewHeaders = ["Personal Info", "Restaurant Preferences", "History", "Logout"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up UITableView delegate/data source
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableFooterView = UIView(frame: CGRectZero)
        profileTableView.separatorInset = UIEdgeInsetsZero
        
        //Set up image view presentation
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.blackColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        //Set user's name and profile image
        if let currentUser = PFUser.currentUser() {
            userFullName.text = "\(currentUser["first_name"]) \(currentUser["last_name"])"
            if let profilePicData = NSUserDefaults.standardUserDefaults().objectForKey("fbProfilePic") as? NSData {
                self.profileImage.image = UIImage(data: profilePicData)
            }
        }
        
        //Create a hidden sign up button for authenticated visits to profile tab
        signUpButton.setTitle("Sign Up to Save Your Profile", forState: .Normal)
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.backgroundColor = UIColor.blackColor()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(ProfileViewController.signUp), forControlEvents: .TouchUpInside)
        self.view.addSubview(signUpButton)
        ProfileViewController.setConstraintsForSignUpButton(signUpButton, toView: self.view, bottomGuide: self.bottomLayoutGuide)
        signUpButton.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        //User is not signed in so show sign up button
        guard PFUser.currentUser()?.email != nil else {
            signUpButton.hidden = false
            profileTableView.hidden = true
            profileImage.hidden = true
            userFullName.hidden = true

            return
        }
        
        //User is signed in so show normal profile content
        //Set user's name and profile image
        let currentUser = PFUser.currentUser()
        userFullName.text = "\(currentUser!["first_name"]) \(currentUser!["last_name"])"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            while NSUserDefaults.standardUserDefaults().objectForKey("fbProfilePic") == nil {
                print("In loop")
                continue
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                let profilePicData = NSUserDefaults.standardUserDefaults().objectForKey("fbProfilePic") as? NSData
                self.profileImage.image = UIImage(data: profilePicData!)
            })
        }
        
        signUpButton.hidden = true
        profileTableView.hidden = false
        profileImage.hidden = false
        userFullName.hidden = false
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableViewHeaders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCellWithIdentifier("profileTableCell", forIndexPath: indexPath)
        cell.textLabel?.text = profileTableViewHeaders[indexPath.row]
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        profileTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch profileTableViewHeaders[indexPath.row] {
        case "Personal Info":
            self.performSegueWithIdentifier("profileToUserInfo", sender: self)
        case "Restaurant Preferences":
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
                self.performSegueWithIdentifier("profileToCuisines", sender: self)
            } else {
                 self.performSegueWithIdentifier("profileToLocation", sender: self)
            }
            break
        case "History":
            break
        case "Logout":
            break
        default:
            break
        }
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
    }
 
    
    static func setConstraintsForSignUpButton(button: UIButton, toView: UIView, bottomGuide: UILayoutSupport) {
        let heightConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 50)
        
        let leadingConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toView,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toView,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: 0)
        
        let centerXConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0)

        let centerYConstraint = NSLayoutConstraint(
            item: button,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: toView,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: 0)

        NSLayoutConstraint.activateConstraints([heightConstraint, leadingConstraint, trailingConstraint, centerXConstraint, centerYConstraint])

    }
    
    func signUp() {
        self.performSegueWithIdentifier("profileToLogin", sender: self)
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
