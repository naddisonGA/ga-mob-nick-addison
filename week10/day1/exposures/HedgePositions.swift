//
//  HedgePositions.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class HedgePositions
{
    var array = [HedgePosition]()
    
    func query(callback: (hedgePositions: [HedgePosition], error: NSError?) -> ())
    {
        var query = HedgePosition.query()!
        
        query.whereKey("open", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.array = objects as! [HedgePosition]
                    
                    NSLog("Successfully retrieved \(self.array.count) open hedge positions.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of bank balances to an empty array
                    self.array = [HedgePosition]()
                }
                
                // return the bank balances or error through the callback
                callback(hedgePositions: self.array, error: error)
        }
    }
}