//
//  Transfers.swift
//  exposures
//
//  Created by Nicholas Addison on 28/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

class Transfer : PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "transfers"
    }
    
    // register this class with the Parse SDK
    override class func initialize() {
        registerSubclass()
    }
    
    @NSManaged var fromEntity: String
    @NSManaged var toEntity: String
    
    @NSManaged var assetCode: String
    
    @NSManaged var quantity: Double
    
    @NSManaged var sendDate: NSDate
    @NSManaged var receivedDate: NSDate
    
    @NSManaged var cleared: Bool
}