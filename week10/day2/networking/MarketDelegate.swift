//
//  MarketDataSourceDelegate.swift
//  networking
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

protocol MarketDelegate
{
    func getTicker(callback: (ticker: Ticker?, erorr: NSError?) -> () )
    func getOrderBook(callback: (orderBook: OrderBook?, erorr: NSError?) -> () )
    func getTrades(callback: (trades: [Trade]?, erorr: NSError?) -> () )
}