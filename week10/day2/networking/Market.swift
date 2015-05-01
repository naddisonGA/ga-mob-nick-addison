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
    
    public var latestTicker: Ticker?
    public var latestOrderBook: OrderBook?
    public var trades: [Trade]?
    
    public var lastTrade: Trade?
    
    //MARK: - initializer
    
    init (exchange: Exchange, instrument: Instrument)
    {
        self.exchange = exchange
        self.instrument = instrument
    }
    
    //MARK:- ticker poller
    
    var tickerPollingInterval: Double = 60  // default to 60 seconds
    
    private var tickerTimer: NSTimer? = nil
    
    func startTickerPoller()
    {
        tickerTimer = NSTimer.scheduledTimerWithTimeInterval(tickerPollingInterval,
            target: self,
            selector: Selector("getTicker"),
            userInfo: nil,
            repeats: true)
    }
    
    // asynchronous call to the exchange to get the latest ticker data
    func getTicker()
    {
        // if the exhcange delegate has been set
        //if let delegate = self.exchange.delegate
        //{
            // asynchronous call to get the latest ticker from the exchange
            self.exchange.getTicker(BTCAUD) {(ticker: Ticker?, erorr: NSError?) in
                
                // No error progressing.
                // Will just set latestTicker to nil if there was an error
                self.latestTicker = ticker
            }
//        }
//        else    // exchange deletgate has not been set
//        {
//            self.latestTicker = nil
//        }
    }
    
    func stopTickerPoller()
    {
        tickerTimer?.invalidate()
    }
    
    //MARK:- order book poller
    
    var orderBookPollingInterval: Double = 60  // default to 60 seconds
    
    private var orderBookTimer: NSTimer? = nil
    
    func startOrderBookPoller()
    {
        orderBookTimer = NSTimer.scheduledTimerWithTimeInterval(tickerPollingInterval,
            target: self,
            selector: Selector("getOrderBook"),
            userInfo: nil,
            repeats: true)
    }
    
    func getOrderBook()
    {
        self.exchange.getOrderBook(BTCAUD) {(orderBook: OrderBook?, erorr: NSError?) in
            self.latestOrderBook = orderBook
        }

    }
    
    func stopOrderBookPoller()
    {
        orderBookTimer?.invalidate()
    }
    
    deinit
    {
        tickerTimer?.invalidate()
        orderBookTimer?.invalidate()
    }
}