//
//  ReservationPopoverViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 8/19/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class ReservationPopoverViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantNeighborhood: UILabel!
    @IBOutlet weak var reservationTime: UILabel!
    @IBOutlet weak var reservationPartySize: UILabel!
    
    //MARK: Properties
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchantName.text = restaurant.name
        if restaurant.neighborhood != "" {
             merchantNeighborhood.text = restaurant.neighborhood
        } else {
            merchantNeighborhood.text = restaurant.address
        }
        
        reservationTime.text = restaurant.reservation.formatReservationTimeString()
        reservationPartySize.text = "\(restaurant.reservation.partySize) people"
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
