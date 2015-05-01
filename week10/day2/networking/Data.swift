//
//  Data.swift
//  FrameworkApp
//
//  Created by Nicholas Addison on 17/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

let AUD = Currency(code: "AUD", name: "Australian Dollar")
let USD = Currency(code: "USD", name: "United States Dollar")
let BTC = Currency(code: "BTC", name: "Bitcoin", percision: 8)
let LTC = Currency(code: "LTC", name: "Litecoin", percision: 8)

let AUDUSD = Instrument(base: AUD, quote: USD)
let BTCAUD = Instrument(base: BTC, quote: AUD)
let BTCUSD = Instrument(base: BTC, quote: USD)
let LTCAUD = Instrument(base: LTC, quote: AUD)
let LTCUSD = Instrument(base: LTC, quote: USD)
let LTCBTC = Instrument(base: LTC, quote: BTC)

var testOrders = [
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Sell, amount: 100, price: 480),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Sell, amount: 3.3, price: 350),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Sell, amount: 1.2, price: 303),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Sell, amount: 9.9, price: 301),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Sell, amount: 0.1, price: 300),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Buy, amount: 0.01, price: 299),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Buy, amount: 0.2, price: 290),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Buy, amount: 3.1, price: 277),
    Order(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Buy, amount: 10.01, price: 255.55)
]
