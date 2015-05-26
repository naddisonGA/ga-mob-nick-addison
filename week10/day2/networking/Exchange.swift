//
//  Exchange.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

public enum ExchangeFeeChargedIn
{
    case BuyAsset
    case SellAsset
    case BaseAsset
    case QuoteAsset
}

public struct ExchangeCommissionRates
{
    let maker: [Asset: Double]
    let taker: [Asset: Double]
    
    init (makerRates: [Asset: Double], takerRates: [Asset: Double])
    {
        self.maker = makerRates
        self.taker = takerRates
    }
    
    init (rates: [Asset: Double])
    {
        self.maker = rates
        self.taker = rates
    }
}

public enum ExchangeNotificationName: String
{
    case Ticker = "ticker"
    case OrderBook = "orderbook"
    case Balance = "balance"
}

//extension Exchange: Equatable {}

public func ==(lhs: Exchange, rhs: Exchange) -> Bool {
    return lhs.name == rhs.name
}

// an entity which multiple instruments can be traded
public protocol Exchange
{
    // unique identifier
    var name: String { get }
    
    // used by equality operator ==
    var hashValue: Int { get }
    
    var markets: [Instrument : Market] { get set }
    
    // user accounts. Note one user can have multiple accounts
    var accounts: [Account] { get set }
    
    var feeChargedIn: ExchangeFeeChargedIn  { get set }
    
    var commissionRates: ExchangeCommissionRates  { get set }
    
    //MARK:- API keys
    
    var keychainKeyForApiKey: String { get }
    var keychainKeyForApiSecret: String { get }
    
    func setKeyOnRouter(apiKey: String, apiSecret: String?)
    
    //MARK:- public asynchronous methods
    
    func getTicker(instrument: Instrument, completionHandler: (ticker: Ticker?, error: NSError?) -> () )
    func getTickers(instruments: [Instrument], completionHandler: (tickers: [Ticker]?, error: NSError?) -> () )
    
    func getOrderBook(instrument: Instrument, completionHandler: (orderBook: OrderBook?, error: NSError?) -> () )
    func getOrderBooks(instruments: [Instrument], completionHandler: (orderBooks: [OrderBook]?, error: NSError?) -> () )
    
    func getTrades(instrument: Instrument, completionHandler: (trades: [Trade]?, error: NSError?) -> () )
    
    //MARK:- private asynchronous methods
    
    func getBalances(completionHandler: (balances: [Balance]?, error: NSError?) -> () )
    
    func addOrder(newOrder: Order, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    func cancelOrder(oldOrder: Order, completionHandler: (error: NSError?) -> () )
    
    func getOrder(exchangeId: String, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    func getOpenOrders(instrument: Instrument, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    
    // func replaceOrder(oldOrder: Order, newOrder: Order, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    
    //MARK:- synchronous helper methods
    func summedBalances(convertedTo: Asset) -> (Balance?, NSError?)
}