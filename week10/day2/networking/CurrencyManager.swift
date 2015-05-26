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
    
    //var currencies = [Currency]()
    //var currencies = [AUD, USD, CNY, NZD, BTC, LTC, DRK]
    var currencies = defaultCurrencyManagerCurrencies
    
    func find(assetCode: String) -> Currency?
    {
        return $.find(currencies) { $0.code == assetCode }
    }
    
    func find(type: CurrencyTyoe) -> [Currency]
    {
        return currencies.filter { $0.type == type }
    }
}