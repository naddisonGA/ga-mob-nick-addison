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
    init (exchange: Exchange, instrument: Instrument,
        ask: Double, bid: Double,
        lastPrice: Double?, timestamp: NSDate?)
    {
        self.exchange = exchange
        self.instrument = instrument
        
        self.ask = ask
        self.bid = bid
        
        self.lastPrice = lastPrice
        self.timestamp = timestamp
    }
    
    // unique identifier of the market, which is an insturment traded on an exchange
    let exchange: Exchange
    let instrument: Instrument
    
    let bid: Double
    let ask: Double
    
    // price of the last trade on the exchange
    let lastPrice: Double?
    
    let timestamp: NSDate?
}
