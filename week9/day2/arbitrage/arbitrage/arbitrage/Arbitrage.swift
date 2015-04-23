//
//  Arbitrage.swift
//  arbitrage
//
//  Created by Nicholas Addison on 23/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

class Arbitrage : PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "arbitrage"
    }
    
    // register this class with the Parse SDK
    override class func initialize() {
        registerSubclass()
    }

    @NSManaged var timestamp: NSDate!
    
    @NSManaged var sellTrade: Trade?
    @NSManaged var buyTrade: Trade?
    
    @NSManaged var variableExchangeRate: Double
    
    // TODO implement return amounts and percentages
    
    var arbReturn: ArbitrageReturn?
    {
        var sellQuantity = 0.0
        var buyQuantity = 0.0
        
        if let linkedSellTrade = sellTrade
        {
            sellQuantity = linkedSellTrade["quantity"] as! Double
        }
        else
        {
            return nil
        }
        
        if let linkedBuyTrade = buyTrade
        {
            buyQuantity = linkedBuyTrade["quantity"] as! Double
        }
        else
        {
            return nil
        }
        
        let sellAmount = Amount(quantity: sellQuantity, assetName: "USD")
        let buyAmount = Amount(quantity: buyQuantity, assetName: "AUD")
        
        return ArbitrageReturn(buyAmount: buyAmount, sellAmount: sellAmount, buyToSellExchangeRate: 0.75)
    }
    
}