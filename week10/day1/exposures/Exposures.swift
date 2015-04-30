//
//  Exposures.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class Exposures
{
    var exchangeBalances = ExchangeBalances()
    var bankBalances = BankBalances()
    var transfers = Transfers()
    var hedgePositions = HedgePositions()
    
    ///
    func query (callback: (error: NSError?) -> ())
    {
        var returnedQueries: Int = 0
        let numberOfQueries: Int = 4
        var failied = false
        
        bankBalances.query {(bankBalances: [BankBalance], error: NSError?) in
            
            returnedQueries++
            
            // if one of the other queries have not already failed
            if !failied
            {
                // if this query has failed
                if error != nil
                {
                    failied = true
                    return callback(error: error);
                }
                
                // if this is the last query to be processed
                if returnedQueries >= numberOfQueries
                {
                    // return callback so processing can be done with all queries having now been completed
                    return callback(error: nil)
                }
            }
        }
        
        exchangeBalances.query {(exchangeBalances: [ExchangeBalance], error: NSError?) in
            
            returnedQueries++
            
            // if one of the other queries have not already failed
            if !failied
            {
                // if this query has failed
                if error != nil
                {
                    failied = true
                    return callback(error: error);
                }
                
                // if this is the last query to be processed
                if returnedQueries >= numberOfQueries
                {
                    // return callback so processing can be done with all queries having now been completed
                    return callback(error: nil)
                }
            }
        }
        
        transfers.query {(transfers: [Transfer], error: NSError?) in
            
            returnedQueries++
            
            // if one of the other queries have not already failed
            if !failied
            {
                // if this query has failed
                if error != nil
                {
                    failied = true
                    return callback(error: error);
                }
                
                // if this is the last query to be processed
                if returnedQueries >= numberOfQueries
                {
                    // return callback so processing can be done with all queries having now been completed
                    return callback(error: nil)
                }
            }
        }
        
        hedgePositions.query {(hedgePositions: [HedgePosition], error: NSError?) in
            
            returnedQueries++
            
            // if one of the other queries have not already failed
            if !failied
            {
                // if this query has failed
                if error != nil
                {
                    failied = true
                    return callback(error: error);
                }
                
                // if this is the last query to be processed
                if returnedQueries >= numberOfQueries
                {
                    // return callback so processing can be done with all queries having now been completed
                    return callback(error: nil)
                }
            }
        }
    }
}