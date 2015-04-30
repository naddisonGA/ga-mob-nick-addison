//
//  ExchangeBalances.swift
//  exposures
//
//  Created by Nicholas Addison on 29/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class ExchangeBalances
{
    var array = [ExchangeBalance]()
    
    func query(callback: (exchangeBalances: [ExchangeBalance], error: NSError?) -> ())
    {
        var query = ExchangeBalance.query()!
        
        query.whereKey("latest", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.array = objects as! [ExchangeBalance]
                    
                    NSLog("Successfully retrieved \(self.array.count) exchange balances.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of bank balances to an empty array
                    self.array = [ExchangeBalance]()
                }
                
                // return the bank balances or error through the callback
                callback(exchangeBalances: self.array, error: error)
        }
    }
}