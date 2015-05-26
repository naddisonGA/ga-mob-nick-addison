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
    var buyAmount: Amount?
    var sellAmount: Amount?
    
    var buyToSellExchangeRate: Double
    
    func amount(assetName: String) -> Double?
    {
        if buyAmount == nil || sellAmount == nil
        {
            return nil
        }
        
        if sellAmount!.assetName == assetName
        {
            return sellAmount!.quantity - buyAmount!.quantity * buyToSellExchangeRate
        }
        else if buyAmount!.assetName == assetName
        {
            return sellAmount!.quantity / buyToSellExchangeRate - buyAmount!.quantity
        }
        else
        {
            return nil
        }
    }
    
    func amount(side: TradeSide) -> Double?
    {
        if buyAmount == nil || sellAmount == nil
        {
            return nil
        }
        
        if side == .Sell
        {
            return sellAmount!.quantity - buyAmount!.quantity * buyToSellExchangeRate
        }
        else if side == .Buy
        {
            return sellAmount!.quantity / buyToSellExchangeRate - buyAmount!.quantity
        }
        else
        {
            return nil
        }
    }
    
    var decimal: Double?
    {
        if buyAmount == nil || sellAmount == nil
        {
            return nil
        }
        
        if let returnAmount = amount(.Buy) {
            return returnAmount / buyAmount!.quantity
        }
        else
        {
            return nil
        }
    }
    
    var percentage: Double?
    {
        if let decimal = decimal {
            return decimal * 100
        }
        else {
            return nil
        }
    }
}