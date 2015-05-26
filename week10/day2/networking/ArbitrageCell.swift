//
//  ArbitrageCell.swift
//  arbitrage
//
//  Created by Nicholas Addison on 23/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import ParseUI

class ArbitrageCell: PFTableViewCell
{

    @IBOutlet weak var timeField: UILabel!
    @IBOutlet weak var returnPercentageField: UILabel!
    @IBOutlet weak var exchangeRateField: UILabel!
    @IBOutlet weak var variableBuyAmountField: UILabel!
    @IBOutlet weak var variableSellAmountField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
