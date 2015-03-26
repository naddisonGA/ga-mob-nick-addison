//
//  Market.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// represents an instrument traded on a specific exchange.
// eg BTCUSD traded on Bitfinex
public class Market
{
    // exchange and instrument is the unique market identifier
    public let exchange: Exchange
    public let instrument: Instrument
    
    public var latestOrderBook: OrderBook?
    public var latestTicker: Ticker?
    
    public var lastTrade: Trade?
    public var trades: [Trade]?
    
    // MARK: - initializer
    
    init (exchange: Exchange, instrument: Instrument)
    {
        self.exchange = exchange
        self.instrument = instrument
    }
}