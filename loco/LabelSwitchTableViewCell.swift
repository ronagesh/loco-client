//
//  LabelSwitchTableViewCell.swift
//  loco
//
//  Created by Rohan Nagesh on 8/2/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit

class LabelSwitchTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var tableViewLabel: UILabel!
    @IBOutlet weak var tableViewSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
