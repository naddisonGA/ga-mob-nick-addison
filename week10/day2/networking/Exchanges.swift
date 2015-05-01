//
//  ExchangeSingleton.swift
//  networking
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

/// Singleton of configured exchanges
class Exchanges {
    
    private var _exchanges: [Exchange] = [btcMarkets]
    
    class var sharedExchanges : Exchanges
    {
        struct Static {
            static let instance = Exchanges()
        }
        return Static.instance
    }
    
    func findExchange(exchangeName: String) -> Exchange?
    {
        
        let filterExchange = _exchanges.filter {$0.name == exchangeName}
        
        return filterExchange.first
    }
    
    func addExchange(exchange: Exchange)
    {
        _exchanges.append(exchange)
    }
}

