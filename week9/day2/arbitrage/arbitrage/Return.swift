//
//  Return.swift
//  arbitrage
//
//  Created by Nicholas Addison on 23/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

struct ArbitrageReturn
{
    var buyAmount: Amount
    var sellAmount: Amount
    
    var buyToSellExchangeRate: Double
    
    // TODO needs to return an error if assetName not in buyAmount or sellAmount
    func amount(assetName: String) -> Double
    {
        if sellAmount.assetName == assetName
        {
            return sellAmount.quantity - buyAmount.quantity * buyToSellExchangeRate
        }
        else
        {
            return sellAmount.quantity / buyToSellExchangeRate - buyAmount.quantity
        }
    }
    
    var decimal: Double
    {
        return amount(buyAmount.assetName) / buyAmount.quantity
    }
    
    var percentage: Double
    {
        return decimal * 100
    }
}