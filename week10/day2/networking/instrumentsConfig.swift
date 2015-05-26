//
//  config.swift
//  networking
//
//  Created by Nicholas Addison on 13/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

let AUD = Currency(code: "AUD", name: "Australian Dollar", type: .Fiat)
let NZD = Currency(code: "NZD", name: "New Zealand Dollar", type: .Fiat)
let USD = Currency(code: "USD", name: "United States Dollar", type: .Fiat)
let CNY = Currency(code: "CNY", name: "China Yuan Renminbi", type: .Fiat)
let CNH = Currency(code: "CNH", name: "China Yuan Renminbi Hong Kong", type: .Fiat)
let BTC = Currency(code: "BTC", name: "Bitcoin", type: .Crypto, percision: 8)
let LTC = Currency(code: "LTC", name: "Litecoin", type: .Crypto, percision: 8)
let DRK = Currency(code: "DRK", name: "Darkcoin", type: .Crypto, percision: 8)

let defaultCurrencyManagerCurrencies: [Currency] = [AUD, USD, CNY, NZD, BTC, LTC, DRK]

let AUDUSD = Instrument(base: AUD, quote: USD)
let USDAUD = Instrument(base: USD, quote: AUD)
let AUDCNY = Instrument(base: AUD, quote: CNY)
let CNYAUD = Instrument(base: CNY, quote: AUD)
let USDCNY = Instrument(base: USD, quote: CNY)
let CNYUSD = Instrument(base: CNY, quote: USD)
let USDCNH = Instrument(base: USD, quote: CNH)
let AUDNZD = Instrument(base: AUD, quote: NZD)
let BTCAUD = Instrument(base: BTC, quote: AUD)
let BTCUSD = Instrument(base: BTC, quote: USD)
let BTCCNY = Instrument(base: BTC, quote: CNY)
let BTCNZD = Instrument(base: BTC, quote: NZD)
let LTCAUD = Instrument(base: LTC, quote: AUD)
let LTCUSD = Instrument(base: LTC, quote: USD)
let LTCCNY = Instrument(base: LTC, quote: CNY)
let LTCBTC = Instrument(base: LTC, quote: BTC)
let DRKUSD = Instrument(base: DRK, quote: USD)
let DRKAUD = Instrument(base: DRK, quote: AUD)

let defaultInstrumentToExchangeMap: [Instrument: Exchange] = [
    AUDUSD: oanda,
    USDCNY: oanda,
    AUDNZD: oanda,
    BTCUSD: bitfinex,
    LTCUSD: bitfinex,
    DRKUSD: bitfinex
]

let defaultCrossRatesMap:[Instrument: [Instrument]] = [
    AUDCNY: [AUDUSD, USDCNY],
    BTCAUD: [BTCUSD, USDAUD],
    DRKAUD: [DRKUSD, USDAUD],
    LTCAUD: [LTCUSD, USDAUD]
]