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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
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
