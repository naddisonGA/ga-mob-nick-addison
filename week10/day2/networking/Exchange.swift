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
    
    //MARK:- public methods
    
    func getTicker(instrument: Instrument, callback: (ticker: Ticker?, error: NSError?) -> () )
    func getTickers(instruments: [Instrument], completionHandler: (tickers: [Ticker]?, error: NSError?) -> () )
    
    func getOrderBook(instrument: Instrument, callback: (orderBook: OrderBook?, error: NSError?) -> () )
    func getOrderBooks(instruments: [Instrument], completionHandler: (orderBooks: [OrderBook]?, error: NSError?) -> () )
    
    func getTrades(instrument: Instrument, callback: (trades: [Trade]?, error: NSError?) -> () )
    
    //MARK:- private methods
    
    func getBalances(callback: (balances: [Balance]?, error: NSError?) -> () )
    
    func addOrder(newOrder: Order, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    func cancelOrder(oldOrder: Order, callback: (error: NSError?) -> () )
    
    func getOrder(exchangeId: String, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    func getOpenOrders(instrument: Instrument, callback: (exchangeOrder: Order?, error: NSError?) -> () )
    
    // optional func replaceOrder(oldOrder: Order, newOrder: Order, callback: (exchangeOrder: Order?, error: NSError?) -> () )
}