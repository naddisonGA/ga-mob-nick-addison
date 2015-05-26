//
//  BTCMarkets.swift
//  networking
//
//  Created by Nicholas Addison on 1/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Security
import CommonCrypto

// Implementation of the BTC Markets bitcoin exchange REST API
// https://github.com/BTCMarkets/API
class BTCMarkets : ExchangeAbstract, Exchange
{
    //MARK:- class constants
    
    let keychainKeyForApiKey: String = "au.com.addisonbrown.api.btcMarkets.key"
    let keychainKeyForApiSecret: String = "au.com.addisonbrown.api.btcMarkets.secret"
    
    let _numberConverter: Double = 100000000
    
    //MARK:- initializers
    
    init (
        name: String,
        instruments: [Instrument],
        commissionRates: ExchangeCommissionRates,
        feeChargedIn: ExchangeFeeChargedIn = .QuoteAsset,
        accounts: [Account] = [Account]() )
    {
        super.init(name: name, feeChargedIn: feeChargedIn, commissionRates: commissionRates)
        super.delegate = self
        
        // for each instrument
        for instrument in instruments
        {
            // create a new market for this new exchange and instrument
            // and add to the markets dictionary
            self.markets[instrument] = Market(exchange: self, instrument: instrument)
        }
        
        self.accounts = accounts
        
        // load API key from Keychain
        setApiKeysFromKeychain()
    }
    
    /// sets the API key and secret stored in the Keychain
    func setKeyOnRouter(apiKey: String, apiSecret: String?) -> ()
    {
        BTCMarketsRouter.apiKey = ApiKey(key: apiKey, secret: apiSecret)
    }
    
    //MARK: - public market data methods
    
    func getTicker(instrument: Instrument, completionHandler: (ticker: Ticker?, error: NSError?) -> () )
    {
        log.debug("About to call \(self.name) ticker API")
        
        Alamofire.request(BTCMarketsRouter.Ticker(instrument))
            .responseJSON { (request, response, json, error) in
                
                if let error = error
                {
                    log.error("Failed to call \(self.name) ticker API: " + error.description)
                    
                    //FIXME:- wrap Alamofire error before returning
                    completionHandler(ticker: nil, error: error)
                    return
                }
                else if let json: AnyObject = json
                {
                    // convert into a SwiftJSON struct
                    let json = JSON(json)
                    
                    log.debug("Successfully called \(self.name) ticker API. JSON: " + json.description)
                    
                    if  let ask = json["bestAsk"].double,
                        let bid = json["bestBid"].double,
                        let lastPrice = json["lastPrice"].double,
                        let timestamp = json["timestamp"].number
                    {
                        let newTicker = Ticker(
                            exchange: self as Exchange,
                            instrument: instrument,
                            ask: ask,
                            bid: bid,
                            lastPrice: lastPrice,
                            timestamp: NSDate(timeIntervalSince1970: timestamp as! NSTimeInterval)
                        )
                        
                        self.markets[instrument]?.latestTicker = newTicker
                        
                        // post ticker to any observers
                        NSNotificationCenter.defaultCenter().postNotificationName(ExchangeNotificationName.Ticker.rawValue, object: newTicker)
                        
                        completionHandler(ticker: newTicker, error: nil)
                        return
                    }
                    else
                    {
                        log.error("Failed to parse \(self.name) ticker data");
                    }
                }
                else
                {
                    log.error("Failed to call \(self.name) ticker API. No JSON data was returned")
                }
                
                //FIXME: - need to return an NSError
                completionHandler(ticker: nil, error: nil)
        }
    }
    
    func getOrderBook(instrument: Instrument, completionHandler: (orderBook: OrderBook?, error: NSError?) -> () )
    {
        log.debug("About to call \(self.name) order book API")
        
        Alamofire.request(BTCMarketsRouter.OrderBook(instrument))
            .responseJSON { (request, response, json, error) in
                
                if let error = error
                {
                    log.error("Failed to call the \(self.name) order book API: " + error.description)
                    
                    completionHandler(orderBook: nil, error: error)
                }
                else if let json: AnyObject = json
                {
                    let json = JSON(json)
                    
                    log.debug("Successfully called \(self.name) order book API: JSON: " + json.description)
                    
                    let bids = self.convertOrdersInOrderBook(json["bids"])
                    let asks = self.convertOrdersInOrderBook(json["asks"])
                    
                    let newOrderBook = OrderBook(
                        bids: bids,
                        asks: asks,
                        timestamp: NSDate(timeIntervalSince1970: json["timestamp"].number as! NSTimeInterval))
                    
                    self.markets[instrument]?.latestOrderBook = newOrderBook
                    
                    // post order book to any observers
                    NSNotificationCenter.defaultCenter().postNotificationName(ExchangeNotificationName.OrderBook.rawValue, object: newOrderBook)
                    
                    completionHandler(orderBook: newOrderBook, error: nil)
                }
        }
    }
    
    private func convertOrdersInOrderBook(orders: JSON) -> [OrderBookOrder]
    {
        // initialize an empty array of order book orders
        var convertedOrders = [OrderBookOrder]()
        
        // for each order in the array of orders
        for (index: String, order: JSON) in orders
        {
            // get price and quantity from the order array
            if  let price = order[0].double,
                let quantity =  order[0].double
            {
                // add converted order to the array that will be returned
                convertedOrders.append(OrderBookOrder(
                    price: price,
                    quantity: quantity
                    ))
            }
            else
            {
                log.debug("Could not parse price or quantity. Price error: \(order[0].error). Quantity error \(order[1].error)")
            }
        }
        
        return convertedOrders
    }
    
    func getTrades(instrument: Instrument, completionHandler: (trades: [Trade]?, error: NSError?) -> () )
    {
        Alamofire.request(BTCMarketsRouter.Trades(instrument))
            .responseJSON { (request, response, JSON, error) in
                
                if error == nil
                {
//                    let new
//                    completionHandler(trades: [newTrade], error: nil)
                }
                else
                {
                    completionHandler(trades: nil, error: error)
                }
        }
    }
    
    //MARK: - private order methods
    
    func getBalances(completionHandler: (balances: [Balance]?, error: NSError?) -> () )
    {
        log.debug("About to call \(self.name) account balance API")
        
        Alamofire.request(BTCMarketsRouter.Balances())
            .responseJSON { (request, response, data, error) in
                
                if let error = error
                {
                    log.error("Failed to call the \(self.name) balance API: " + error.description)
                    
                    completionHandler(balances: nil, error: error)
                }
                else if let data: AnyObject = data
                {
                    let json = JSON(data)
                    
                    log.debug("json response from \(self.name) balances API: \(json.description)")
                    
                    if let errorMessage = json["errorMessage"].string
                    {
                        //TODO:- construct a new NSError with nested Alamoire error and return in callback
                        log.error("Failed to call the \(self.name) balance API: " + errorMessage)
                        return completionHandler(balances: nil, error: nil)
                    }
                    
                    if let exchangeBalances = json.array
                    {
                        log.debug("Successfully retireved \(exchangeBalances.count) account balances from \(self.name)")
                        
                        var newBalances = [Balance]()
                        
                        for balance in exchangeBalances
                        {
                            if let currencyCode: String = balance["currency"].string
                            {
                                if let currency = CurrencyManager.sharedCurrencyManager.find(currencyCode)
                                {
                                    var newBalance = Balance(asset: currency)
                                    
                                    if let total: Double = balance["balance"].double,
                                        let pendingFunds: Double = balance["pendingFunds"].double
                                    {
                                        newBalance.total = total / self._numberConverter
                                        newBalance.available = (total - pendingFunds) / self._numberConverter
                                        
                                        newBalances.append(newBalance)
                                    }
                                    else
                                    {
                                        //TODO:- log error
                                        println("could not parse the balance or pendingFunds fields")
                                    }
                                }
                            }
                            else
                            {
                                println(balance["currency"].error)
                            }
                        }
                        
                        // add new balances to the Exchange account
                        //FIXME: need support for multiple accounts on a single exchange
                        // for now will assume there is only one account on the exchange.
                        // that is, the balances belong to the first account
                        self.accounts.first?.balances = newBalances
                        
                        // return newly instanciated balances in the callback
                        completionHandler(balances: newBalances, error: nil)
                    }
                    else
                    {
                        //TODO:- log error and return in callback
                    }
                }
        }
    }
}