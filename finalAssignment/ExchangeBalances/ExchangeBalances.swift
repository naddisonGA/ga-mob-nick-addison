//
//  ExchangeBalances.swift
//  ExchangeBalances
//
//  Created by Nicholas Addison on 8/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

struct Balance
{
    var currency: String
    var total: Double = 0.0
    var available: Double = 0.0
}

struct Exchange {
    var name: String
    var balances = [Balance]()
}

var exchangeBalances = [
    Exchange(name: "BTC Markets",
        balances: [
            Balance(currency: "BTC", total: 5.5, available: 2.2),
            Balance(currency: "AUD", total: 12343.21, available: 0.01),
            Balance(currency: "LTC", total: 0, available: 0)
        ]
    ),
    
    Exchange(name: "Bitfinex",
        balances: [
            Balance(currency: "BTC", total: 10.12345678, available: 9.87654321),
            Balance(currency: "USD", total: 21456.78, available: 19876.54)
        ]
    )
    
]