//
//  TotalAmounts.swift
//  ExchangeBalances
//
//  Created by Nicholas Addison on 8/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

struct TotalAmount
{
    var description: String
    var currencyTotals: [String: Double]
}

var totalAmounts = [
    TotalAmount(description: "fiat", currencyTotals: ["USD": 20000, "AUD": 26000]),
    TotalAmount(description: "crypto", currencyTotals: ["USD": 10000, "AUD": 13000]),
    TotalAmount(description: "hedge", currencyTotals: ["USD": 5000, "AUD": 6500]),
]
