//
//  EateryDetailTableViewCell.swift
//  UITableView
//
//  Created by Konstantin on 04/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class EateryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
