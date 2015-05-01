//
//  BTCMarkets.swift
//  networking
//
//  Created by Nicholas Addison on 1/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire

//let btcMarketsMarketDelegate =

// instance of BTC Markets
let btcMarkets = BTCMarkets(
    name: "BTC Markets",
    instruments: [BTCAUD, LTCAUD, LTCBTC],
    commissionRates: ExchangeCommissionRates(rates: [AUD: 0.001, USD: 0.001, BTC: 0.001]),
    feeChargedIn: .QuoteAsset)

class BTCMarkets : ExchangeAbstract, Exchange
{
    var server = "https://api.btcmarkets.net/"
    
    init (name: String, instruments: [Instrument], commissionRates: ExchangeCommissionRates, feeChargedIn: ExchangeFeeChargedIn = .BuyAsset)
    {
        super.init(name: name, feeChargedIn: feeChargedIn, commissionRates: commissionRates)
        super.delegate = self
        
        // initialise to an empty dictionary
        self.markets = [Instrument : Market]()
        
        // for each instrument
        for instrument in instruments
        {
            // create a new market for this new exchange and instrument
            // and add to the markets dictionary
            self.markets[instrument] = Market(exchange: self, instrument: instrument)
        }
    }
    
    func marketPath(instrument: Instrument, action: String) -> String
    {
        return "/market/" + instrument.baseAsset.code + "/" + instrument.quoteAsset.code + "/" + action
    }
    
    func getTicker(instrument: Instrument, callback: (ticker: Ticker?, error: NSError?) -> () )
    {
        let path = marketPath(instrument, action: "tick")
        
        Alamofire.request(.GET, server + path)
            .responseJSON { (request, response, JSON, error) in
                
                if error == nil
                {
                    let newTicker = Ticker(
                        exchange: self as Exchange,
                        instrument: instrument,
                        bid: JSON!.valueForKey("bestBid") as! Double,
                        ask: JSON!.valueForKey("bestAsk") as! Double,
                        lastPrice: (JSON!.valueForKey("lastPrice") as! Double),
                        timestamp: NSDate(timeIntervalSince1970: JSON!.valueForKey("timestamp") as! NSTimeInterval)
                        )
                    
                    self.markets[instrument]?.latestTicker = newTicker
                    
                    callback(ticker: newTicker, error: nil)
                }
                else
                {
                    callback(ticker: nil, error: error)
                }
        }
    }
    
    func getOrderBook(instrument: Instrument, callback: (orderBook: OrderBook?, error: NSError?) -> () )
    {
        let path = marketPath(instrument, action: "orderbook")
        
        Alamofire.request(.GET, server + path)
            .responseJSON { (request, response, JSON, error) in
                
                if error == nil
                {
                    let bids = self.convertOrdersInOrderBook(JSON!.valueForKey("bids") as! [[Double]])
                    let asks = self.convertOrdersInOrderBook(JSON!.valueForKey("asks") as! [[Double]])
                    
                    let newOrderBook = OrderBook(
                        bids: bids,
                        asks: asks,
                        timestamp: NSDate(timeIntervalSince1970: JSON!.valueForKey("timestamp") as! NSTimeInterval))
                    
                    self.markets[instrument]?.latestOrderBook = newOrderBook
                    
                    callback(orderBook: newOrderBook, error: nil)
                }
                else
                {
                    callback(orderBook: nil, error: error)
                }
        }
    }
    
    func convertOrdersInOrderBook(JSONOrders: [[Double]]) -> [OrderBookOrder]
    {
        var convertedOrders = [OrderBookOrder]()
        
        for order in JSONOrders
        {
            convertedOrders.append(OrderBookOrder(
                price: order[0],
                quantity: order[1]
                ))
        }
        
        return convertedOrders
    }
    
    func getTrades(instrument: Instrument, callback: (trades: [Trade]?, error: NSError?) -> () )
    {
        let path = marketPath(instrument, action: "trades")
        
        Alamofire.request(.GET, server + path)
            .responseJSON { (request, response, JSON, error) in
                
                if error == nil
                {
//                    let newTrade = Trade(
//                        exchange: self as Exchange,
//                        instrument: instrument,
//                        timestamp: NSDate(timeIntervalSince1970: JSON!.valueForKey("timestamp") as! NSTimeInterval)
//                    )
//                    
//                    callback(trades: [newTrade], error: nil)
                }
                else
                {
                    callback(trades: nil, error: error)
                }
        }
    }
    
    //MARK: - private methods
    
    func addOrder(newOrder: Order, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    {
        
    }
    
    func cancelOrder(oldOrder: Order, callback: (error: NSError?) -> () )
    {
        
    }
    
    func getOrder(exchangeId: String, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    {
        
    }
    
    func getOpenOrders(instrument: Instrument, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    {
        
    }
}