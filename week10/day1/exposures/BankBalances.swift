//
//  BankBalances.swift
//  exposures
//
//  Created by Nicholas Addison on 29/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class BankBalances
{
    var array = [BankBalance]()
    
    func query(callback: (bankBalances: [BankBalance], error: NSError?) -> ())
    {
        var query = BankBalance.query()!
        
        query.whereKey("latest", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.array = objects as! [BankBalance]
                    
                    NSLog("Successfully retrieved \(self.array.count) bank balances.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of bank balances to an empty array
                    self.array = [BankBalance]()
                }
                
                // return the bank balances or error through the callback
                callback(bankBalances: self.array, error: error)
        }
    }
    
    func aggregatedBalances() -> [String: Double]
    {
        var aggregatedBalances = [String: Double]()
        
        for bankBalance in self.array
        {
            if aggregatedBalances[bankBalance.assetName] != nil
            {
                aggregatedBalances[bankBalance.assetName]! += bankBalance.balance
            }
            else
            {
                aggregatedBalances[bankBalance.assetName] = bankBalance.balance
            }
        }
        
        return aggregatedBalances
    }
}