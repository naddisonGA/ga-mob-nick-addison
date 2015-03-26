//
//  Errors.swift
//  FrameworkApp
//
//  Created by Nicholas Addison on 13/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

let domainTP = "au.com.addisonbrown.tradingplatform"

// tradingPlatform errors
enum Errors: Int {
    case OrderOpen = 1
    case OrderCancel,
    OrderBookGetVwapInvalidRequiredAmount,
    OrderBookGetVwapNotEnoughInOrderBook,
    OrderAddTradeInvaidExchange,
    OrderAddTradeInvaidInstrument
}

// error object for the trading platform
class Error : NSError
{
    init(code: Int, userInfo: [NSObject : AnyObject]?)
    {
        super.init(domain: domainTP, code: code, userInfo: userInfo)
    }
    
    required init(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}