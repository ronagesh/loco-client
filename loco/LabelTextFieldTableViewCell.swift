//
//  LabelTextFieldTableViewCell.swift
//  loco
//
//  Created by Rohan Nagesh on 8/2/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Parse

class LabelTextFieldTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var tableRowLabel: UILabel!
    @IBOutlet weak var tableViewTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
