//
//  TotalsDescriptionCell.swift
//  ExchangeBalances
//
//  Created by Nicholas Addison on 8/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class TotalsDescriptionCell: UITableViewCell {

    @IBOutlet weak var amountDescriptionField: UILabel!
    @IBOutlet weak var usdAmountField: UILabel!
    @IBOutlet weak var audAmountField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
