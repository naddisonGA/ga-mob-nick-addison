//
//  ExchangeSingleton.swift
//  networking
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Dollar

/// Singleton of configured exchanges
class ExchangeManager
{
    var exchanges = [Exchange]()
    
    static let sharedExchangeManager = ExchangeManager()
    
    func findExchange(exchangeName: String) -> Exchange?
    {
        return $.find(exchanges) { $0.name == exchangeName }
    }
    
    // gets the latest balances from all the configured exchanges asynchronously in parallel
    // the callback is called when either
    // 1. all exchange balances have been retreived from all the exchanges
    // 2. there is an error from one of the exchanges
    // note that the callback will only be called once if there are multiple errors across the exchanges. The first error received will be returned and the supsequant errors will be ignored as the callback has already been called
    func getAllBalances(completionHandler: (error: NSError?) -> () )
    {
        func iteratorFunc(exchange: Exchange, iteratorCompletionHandler: (balances: [Balance]?, error: NSError?) -> () )
        {
            exchange.getBalances(iteratorCompletionHandler)
        }
        
        Async.each(
            exchanges,
            iterator: iteratorFunc)
        {
            (balances: [Balance]?, error) in
            
            completionHandler(error: error)
        }
    }
    
    // sums the cached balances converted to the desired currency across all the configred exchanges
    // this is a synchronous method. The latest balances are not retrived from the exchanges
    func totalBalance(convertedTo: Asset) -> (Double?, NSError?)
    {
        var totalBalance: Double = 0
        
        // for each configured exchange
        for exchange in exchanges
        {
            // synchronously sum the cached exchange balances using the cached exchange rates
            let (summedBalance, error) = exchange.summedBalances(convertedTo)
            
            if let summedBalance = summedBalance
            {
                totalBalance += summedBalance.total
            }
            else if let error = error
            {
                log.error(error.debugDescription)
                
                // if a required exchange rate has not been cached
                return (nil, error)
            }
            
        }
        
        return (totalBalance, nil)
    }
}
