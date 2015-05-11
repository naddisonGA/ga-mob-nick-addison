//
//  Transfers.swift
//  exposures
//
//  Created by Nicholas Addison on 29/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class Transfers
{
    var array = [Transfer]()
    
    func query(callback: (transfers: [Transfer], error: NSError?) -> ())
    {
        var query = Transfer.query()!
        
        query.whereKey("cleared", equalTo: false)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.array = objects as! [Transfer]
                    
                    println("Successfully retrieved \(self.array.count) transfers.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of transfers to an empty array
                    self.array = [Transfer]()
                }
                
                // return the bank balances or error through the callback
                callback(transfers: self.array, error: error)
        }
    }
}