//
//  ExchangeBalancesTableViewCell.swift
//  networking
//
//  Created by Nicholas Addison on 8/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class ExchangeBalancesTableViewCell: UITableViewCell
{

    @IBOutlet weak var currencyField: UILabel!
    @IBOutlet weak var availableField: UILabel!
    @IBOutlet weak var totalField: UILabel!
    @IBOutlet weak var audField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
