//
//  Ticker.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

public class Ticker
{
    // unique identifier of the market, which is an insturment traded on an exchange
    let exchange: Exchange
    let instrument: Instrument
    
    let bid: Double
    let ask: Double
    
    // price of the last trade on the exchange
    let lastPrice: Double?
    
    let timestamp: NSDate
    
    // MARK: - initializer
    
    init (exchange: Exchange, instrument: Instrument, bid: Double, ask: Double, last: Double? = nil, timestamp: NSDate = NSDate() )
    {
        self.exchange = exchange
        self.instrument = instrument
        
        self.bid = bid
        self.ask = ask
        
        self.timestamp = timestamp
    }
}
