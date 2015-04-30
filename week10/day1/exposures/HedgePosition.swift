//
//  HedgePositions.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

class HedgePosition: PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "HedgePositions"
    }
    
    // register this class with the Parse SDK
    override class func initialize() {
        registerSubclass()
    }
    
    @NSManaged var institutionName: String
    @NSManaged var instrumentCode: String
    
    @NSManaged var side: String
    
    @NSManaged var quantity: Double
    @NSManaged var price: Double
    
    @NSManaged var stopLoss: Double
    @NSManaged var takeProfit: Double
    
    @NSManaged var open: Bool
    @NSManaged var openTime: NSDate
    @NSManaged var closeTime: NSDate
}