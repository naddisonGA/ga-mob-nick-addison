//
//  Trade.swift
//  arbitrage
//
//  Created by Nicholas Addison on 23/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

enum TradeSide {
    case Sell
    case Buy
}

class Trade : PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "trade"
    }
    
    // register this class with the Parse SDK
    override class func initialize() {
        registerSubclass()
    }
    
    @NSManaged var exchangeName: String!
    @NSManaged var instrumentName: String!
    
    //@NSManaged var side: TradeSide!
    
    @NSManaged var price: Double
    @NSManaged var quantity: Double
    
    // TODO define dee struct
    @NSManaged var fee: [String: String]
}