//
//  Exposures.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class ExposureManager
{
    static let sharedExposureManager = ExposureManager()
    
    func aggregatedLongPosition(asset: Asset) -> Double
    {
        let (exchangeBalance, exchangeError) = ExchangeManager.sharedExchangeManager.totalBalance(asset)
        
        return exchangeBalance! +
            BankBalanceManager.sharedBankBalanceManager.aggregatedBalance(ofAssetCode: asset.code) +
            TransferManager.sharedTransferManager.aggregatedQuantity(ofAssetCode: asset.code)
    }
    
    func aggregatedShortPosition(asset: Asset) -> Double
    {
        return HedgePositionManager.sharedHedgePositionManager.aggregatedQuantity(ofAssetCode: asset.code)
    }
    
    func aggregatedExposure(asset: Asset) -> Exposure
    {
        let longPositions = aggregatedLongPosition(asset)
        let shortPositions = aggregatedShortPosition(asset)
        
        return Exposure(
            asset: asset,
            longPosition: longPositions,
            shortPosition: shortPositions)
    }
    
    /// queries all 4 Parse classes and calls the trailing closure ones all 4 have been queried
    /// if there is an error in any of the queries then an error is returned in the callback immediately
    func query (callback: (error: NSError?) -> ())
    {
        //TODO: change to Async.parallel
        var returnedQueries: Int = 0
        let numberOfQueries: Int = 3
        var failied = false
        
        BankBalanceManager.sharedBankBalanceManager.query {(bankBalances: [BankBalance], error: NSError?) in
            
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
        
        TransferManager.sharedTransferManager.query {(transfers: [Transfer], error: NSError?) in
            
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
        
        HedgePositionManager.sharedHedgePositionManager.query {(hedgePositions: [HedgePosition], error: NSError?) in
            
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