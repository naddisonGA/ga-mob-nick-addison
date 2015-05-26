//
//  ExchangeBalancesHeaderTableViewCell.swift
//  networking
//
//  Created by Nicholas Addison on 8/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class ExchangeBalancesHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var exchangeNameField: UILabel!
    @IBOutlet weak var exchangeAUDTotalField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
