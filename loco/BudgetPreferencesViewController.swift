//
//  BudgetPreferencesViewController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/13/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class BudgetPreferencesViewController: UIViewController {

    @IBOutlet weak var budgetSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetSlider.continuous = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func budgetSliderChanged() {
        budgetSlider.setValue(Float(lroundf(budgetSlider.value)), animated: true)
    }


    @IBAction func budgetSliderTapped(sender: UITapGestureRecognizer) {
        let sliderStartingX = Float(budgetSlider.frame.minX)
        let sliderEndingX = Float(budgetSlider.frame.maxX)
        let numSliderSegments = budgetSlider.maximumValue - budgetSlider.minimumValue
        let sliderInterval = (sliderEndingX - sliderStartingX) / numSliderSegments
        
        let tappedPointXCoord = Float(sender.locationInView(self.view).x)

        var cursor = sliderStartingX
        
        for i in 1...Int(numSliderSegments) {
            if tappedPointXCoord <= (cursor + (sliderInterval / 2)) {
                budgetSlider.setValue(budgetSlider.minimumValue + Float(i-1), animated: true)
                break
            } else if tappedPointXCoord <= (cursor + sliderInterval) {
                budgetSlider.setValue(budgetSlider.minimumValue + Float(i), animated: true)
                break
            } else {
                cursor += sliderInterval
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
