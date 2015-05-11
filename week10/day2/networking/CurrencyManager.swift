//
//  CurrencyManager.swift
//  networking
//
//  Created by Nicholas Addison on 6/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Dollar

class CurrencyManager
{
    static let sharedCurrencyManager = CurrencyManager()
    
    var currencies = [AUD, USD, BTC, LTC, DRK]
    
    func find(assetCode: String) -> Currency?
    {
        return $.find(currencies) { $0.code == assetCode }
    }
    
    func find(type: CurrencyTyoe) -> [Currency]
    {
        return currencies.filter { $0.type == type }
    }
}

let AUD = Currency(code: "AUD", name: "Australian Dollar", type: .Fiat)
let USD = Currency(code: "USD", name: "United States Dollar", type: .Fiat)
let CNY = Currency(code: "CNY", name: "China Yuan Renminbi", type: .Fiat)
let CNH = Currency(code: "CNH", name: "China Yuan Renminbi Hong Kong", type: .Fiat)
let BTC = Currency(code: "BTC", name: "Bitcoin", type: .Crypto, percision: 8)
let LTC = Currency(code: "LTC", name: "Litecoin", type: .Crypto, percision: 8)
let DRK = Currency(code: "DRK", name: "Darkcoin", type: .Crypto, percision: 8)