//
//  TradeDataSourceDelegate.swift
//  networking
//
//  Created by Nicholas Addison on 1/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

protocol ExchangeDelegate
{
    //MARK: - public methods
    
    func getTicker(instrument: Instrument, callback: (ticker: Ticker?, error: NSError?) -> () )
    func getOrderBook(instrument: Instrument, callback: (orderBook: OrderBook?, error: NSError?) -> () )
    func getTrades(instrument: Instrument, callback: (trades: [Trade]?, error: NSError?) -> () )
    
    //MARK: - private methods
    
    func addOrder(newOrder: Order, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    func cancelOrder(oldOrder: Order, callback: (error: NSError?) -> () )
    
    func getOrder(exchangeId: String, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    func getOpenOrders(instrument: Instrument, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    
    // optional func replaceOrder(oldOrder: Order, newOrder: Order, callback: (exchangeOrder: Order?, error: NSError?) -> () )
}