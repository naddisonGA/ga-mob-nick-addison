//
//  Trade.swift
//  arbitrage
//
//  Created by Nicholas Addison on 23/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

class TradePF : PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "trade"
    }
    
    @NSManaged var exchangeName: String!
    @NSManaged var instrumentCode: String!
    
    @NSManaged var typeCode: String!
    @NSManaged var sideCode: String!
    
    @NSManaged var price: Double
    @NSManaged var quantity: Double
    
    // TODO define fee struct
    @NSManaged var fee: [String: String]
    
    @NSManaged var timestamp: NSDate!
}

enum TradeSide {
    case Sell
    case Buy
}