//
//  BalanceCell.swift
//  ExchangeBalances
//
//  Created by Nicholas Addison on 7/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class BalanceCell: UITableViewCell {

    @IBOutlet weak var currencyField: UILabel!
    @IBOutlet weak var totalAmountField: UILabel!
    @IBOutlet weak var availableAmountField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
