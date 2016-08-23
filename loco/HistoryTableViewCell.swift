//
//  HistoryTableViewCell.swift
//  loco
//
//  Created by Rohan Nagesh on 8/20/16.
//  Copyright © 2016 Rohan Nagesh. All rights reserved.
//

import UIKit
import Cosmos

class HistoryTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var merchantImage: UIImageView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var reservationDate: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
