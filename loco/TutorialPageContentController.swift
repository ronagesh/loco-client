//
//  TutorialPageContentController.swift
//  loco
//
//  Created by Rohan Nagesh on 7/8/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class TutorialPageContentController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var pageImage: UIImageView!
    @IBOutlet weak var pageBlurb: UILabel!

    //MARK: Properties
    var blurbString = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImage.image = UIImage(named: imageName)
        pageBlurb.text = blurbString
        
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
