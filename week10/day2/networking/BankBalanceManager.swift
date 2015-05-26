//
//  BankBalances.swift
//  exposures
//
//  Created by Nicholas Addison on 29/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

/// Singleton to manage the collection of bank balances stored in Parse
class BankBalanceManager
{
    // collection of bank balances stored in Parse
    private var bankBalances = [BankBalance]()
    
    static let sharedBankBalanceManager = BankBalanceManager()
    
    func aggregatedBalance(ofAssetCode assetCode: String) -> Double
    {
        // sum the balance property
        let aggregatedQuantity: Double = self.bankBalances
            .map {
                if $0.assetCode == assetCode {
                    return $0.balance
                }
                else {
                    return 0
                }
            }
            .reduce(0) {return $0 + $1}
        
        return aggregatedQuantity
    }
    
    func query(callback: (bankBalances: [BankBalance], error: NSError?) -> ())
    {
        var query = BankBalance.query()!
        
        query.whereKey("latest", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.bankBalances = objects as! [BankBalance]
                    
                    NSLog("Successfully retrieved \(self.bankBalances.count) bank balances.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of bank balances to an empty array
                    self.bankBalances = [BankBalance]()
                }
                
                // return the bank balances or error through the callback
                callback(bankBalances: self.bankBalances, error: error)
        }
    }
    
    func aggregatedBalances() -> [String: Double]
    {
        var aggregatedBalances = [String: Double]()
        
        for bankBalance in self.bankBalances
        {
            if aggregatedBalances[bankBalance.assetCode] != nil
            {
                aggregatedBalances[bankBalance.assetCode]! += bankBalance.balance
            }
            else
            {
                aggregatedBalances[bankBalance.assetCode] = bankBalance.balance
            }
        }
        
        return aggregatedBalances
    }
}