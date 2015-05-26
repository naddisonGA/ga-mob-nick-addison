//
//  exchangeBalance.swift
//  exposures
//
//  Created by Nicholas Addison on 29/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

class ExchangeBalance: PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "exchangeBalance"
    }
    
    // register this class with the Parse SDK
    override class func initialize() {
        registerSubclass()
    }
    
    @NSManaged var institutionName: String
    @NSManaged var assetCode: String
    
    @NSManaged var balance: Double
    @NSManaged var available: Double
    
    @NSManaged var latest: Bool
    @NSManaged var timestamp: NSDate
}