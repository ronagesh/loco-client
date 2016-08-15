//
//  UserInfoViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/2/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var userInfoTableView: UITableView!
    
    let userInfoLabels = ["Name", "Email", "Phone"]
    let connectedAccountsLabels = ["Facebook", "Uber"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        userInfoTableView.tableFooterView = UIView(frame: CGRectZero)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        //MARK: Table View Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
        if section == 0 {
            return userInfoLabels.count
        } else {
            return connectedAccountsLabels.count
        }*/
        
        return userInfoLabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let currentUser = PFUser.currentUser() else {
            print("No user details to show")
            return UITableViewCell()
        }
        
        if indexPath.section == 0 { //In user info section
            //let cell = LabelTextFieldTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "labelTextFieldCell")
            let cell = userInfoTableView.dequeueReusableCellWithIdentifier("labelTextFieldCell", forIndexPath: indexPath) as! LabelTextFieldTableViewCell
            
            cell.tableRowLabel.text = userInfoLabels[indexPath.row]
            cell.tableViewTextField.delegate = self

            switch userInfoLabels[indexPath.row] {
            case "Name":
                cell.tableViewTextField.text = "\(currentUser["first_name"]) \(currentUser["last_name"])"
                return cell
            case "Email":
                cell.tableViewTextField.text = "\(currentUser.email!)"
                return cell
            case "Phone":
                cell.tableViewTextField.text = "\(currentUser["phone"])"
                return cell
            default:
                return cell
            }
        } /*else { //In connected accounts section
            switch connectedAccountsLabels[indexPath.row] {
            case "Facebook":
                cell.
                break
            case "Uber":
                break
            default:
                break
            }
        } */
        
        return UITableViewCell()
    }
    
    //MARK: Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        guard let currentUser = PFUser.currentUser() else {
            print("No user to save details for")
            return
        }

        
        let position = textField.convertRect(textField.frame, toView: userInfoTableView)
        let indexPaths = userInfoTableView.indexPathsForRowsInRect(position)
        let indexPath = indexPaths![0]
        
        if indexPath.section == 0 {
            switch userInfoLabels[indexPath.row] {
            case "Name":
                if let fullName = textField.text?.componentsSeparatedByString(" ") {
                    currentUser["first_name"] = fullName[0]
                    currentUser["last_name"] = fullName[1]
                    currentUser.saveInBackgroundWithBlock({ (success, error) in
                        if error != nil {
                            print ("Error updating user info")
                        } else {
                            print("Successfully updated user's name")
                        }
                    })
                }
                
                break
            case "Email":
                currentUser.email = textField.text
                currentUser.saveInBackgroundWithBlock({ (success, error) in
                    if error != nil {
                        print ("Error updating user info")
                    } else {
                        print("Successfully updated user's email")
                    }
                })

                break
            case "Phone":
                currentUser["phone"] = textField.text
                currentUser.saveInBackgroundWithBlock({ (success, error) in
                    if error != nil {
                        print ("Error updating user info")
                    } else {
                        print("Successfully updated user's phone")
                    }
                })

                break
            default:
                break
            }
        } /*else {
            switch connectedAccountsLabels[indexPath.row] {
            case "Facebook":
                break
            case "Uber":
                break
            default:
                break
            }
        } */
    }
    
    @IBAction func saveUserInfo(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("userInfoToProfile", sender: self)

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
