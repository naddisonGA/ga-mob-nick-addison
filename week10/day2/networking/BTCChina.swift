//
//  BTCChina.swift
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

// Implementation of the BTC China bitcoin exchange REST API
// http://btcchina.org/api-trade-documentation-en

class BTCChina : ExchangeAbstract, Exchange
{
    //MARK:- class constants
    
    let keychainKeyForApiKey: String = "au.com.addisonbrown.api.btcChina.key"
    let keychainKeyForApiSecret: String = "au.com.addisonbrown.api.btcChina.secret"
    
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
        BTCChinaRouter.apiKey = ApiKey(key: apiKey, secret: apiSecret)
    }
    
    //MARK: - public market data methods
    
    func getTicker(instrument: Instrument, completionHandler: (ticker: Ticker?, error: NSError?) -> () )
    {
        let methodDescription = "\(self.name) Ticker API for \(instrument.code(.UpperCase))"
        
        log.debug("About to call \(methodDescription)")
        
        var returnError: NSError? = nil
        var newTicker: Ticker? = nil
        
        Alamofire.request(BTCChinaRouter.Ticker(instrument))
            .responseJSON
            {
                request, response, json, error in
                
                if let error = error
                {
                    returnError = ABTradingError.Create("\(methodDescription) failed with error: \(error.description))").error
                }
                else if let json: AnyObject = json
                {
                    // convert into a SwiftJSON struct
                    let json = JSON(json)
                    
                    log.debug("Successfully called \(methodDescription). JSON:\n\(json.description)")
                    
                    if  let askStr = json["ticker","sell"].string,
                        let bidStr = json["ticker","buy"].string,
                        let lastPriceStr = json["ticker","last"].string,
                        let date = json["ticker","date"].double
                    {
                        newTicker = Ticker(
                            exchange: self as Exchange,
                            instrument: instrument,
                            ask: (askStr as NSString).doubleValue,
                            bid: (bidStr as NSString).doubleValue,
                            lastPrice: (lastPriceStr as NSString).doubleValue,
                            timestamp: NSDate(timeIntervalSince1970: date)
                        )
                        
                        self.markets[instrument]?.latestTicker = newTicker
                        
                        // post ticker to any observers
                        NSNotificationCenter.defaultCenter().postNotificationName(ExchangeNotificationName.Ticker.rawValue, object: newTicker)
                    }
                    else
                    {
                        returnError = ABTradingError.Create("\(methodDescription) failed. Could not parse ticker data: \(json.description)").error
                    }
                }
                else
                {
                    returnError = ABTradingError.Create("\(methodDescription) failed. No JSON data was returned").error
                }
                
                if let error = returnError {
                    log.error(error.debugDescription)
                }
                
                completionHandler(ticker: newTicker, error: returnError)
        }
    }
    
    
    func getOrderBook(instrument: Instrument, completionHandler: (orderBook: OrderBook?, error: NSError?) -> () )
    {
        let methodDescription = "\(self.name) Order Book API for \(instrument.code(.UpperCase))"
        
        log.debug("About to call " + methodDescription)
        
        var returnError: NSError? = nil
        var newOrderBook: OrderBook? = nil
        
        Alamofire.request(BTCChinaRouter.OrderBook(instrument))
            .responseJSON
            {
                request, response, json, error in
                
                if let error = error
                {
                    returnError = ABTradingError.Create("\(methodDescription) failed with error: \(error.description)").error
                }
                else if let json: AnyObject = json
                {
                    let json = JSON(json)
                    
                    log.debug("Successfully called \(methodDescription)")
                    
                    let (bids, bidError) = self.convertOrdersInOrderBook(json["bids"])
                    let (asks, askError) = self.convertOrdersInOrderBook(json["asks"])
                    
                    if (bidError != nil)
                    {
                        returnError = bidError
                    }
                    else if (askError != nil)
                    {
                        returnError = askError
                    }
                    else
                    {
                        newOrderBook = OrderBook(
                            bids: bids,
                            asks: asks,
                            timestamp: NSDate())
                        
                        self.markets[instrument]?.latestOrderBook = newOrderBook
                        
                        // post order book to any observers
                        NSNotificationCenter.defaultCenter().postNotificationName(ExchangeNotificationName.OrderBook.rawValue, object: newOrderBook)
                    }
                }
                else
                {
                    returnError = ABTradingError.Create("\(methodDescription) failed. No JSON data was returned").error
                }
                
                if let error = returnError {
                    log.error(error.debugDescription)
                }
                
                completionHandler(orderBook: newOrderBook, error: returnError)
        }
    }
    
    private func convertOrdersInOrderBook(orders: JSON) -> ([OrderBookOrder], NSError?)
    {
        // initialize an empty array of order book orders
        var convertedOrders = [OrderBookOrder]()
        
        var error: NSError? = nil
        
        // for each order in the array of orders
        for (index: String, order: JSON) in orders
        {
            // get price and quantity from the order array
            if  let price = order[0].double,
                let quantity =  order[1].double
            {
                // add converted order to the array that will be returned
                convertedOrders.append(OrderBookOrder(
                    price: price,
                    quantity: quantity
                    ))
            }
            else
            {
                error = ABTradingError.Create("Could not parse price or amount in order. JSON:\n\(order)").error
                break
            }
        }
        
        return (convertedOrders, error)
    }
    
    func getTrades(instrument: Instrument, completionHandler: (trades: [Trade]?, error: NSError?) -> () )
    {
        Alamofire.request(BTCMarketsRouter.Trades(instrument))
            .responseJSON
            {
                request, response, JSON, error in
                
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
        let methodDescription = "\(self.name) Balances API"
        
        log.debug("About to call " + methodDescription)
        
        var returnError: NSError? = nil
        var newBalances = [Balance]()
        
        Alamofire.request(BTCChinaRouter.Balances())
            .responseJSON
            {
                request, response, data, error in
                
                if let error = error
                {
                    returnError = ABTradingError.Create("\(methodDescription) failed. Error: \(error.description)").error
                }
                else if let data: AnyObject = data
                {
                    let json = JSON(data)
                    
                    log.debug("Successfully called \(methodDescription). JSON: \(json.description)")
                    
                    if let errorMessage = json["message"].string
                    {
                        let returnError = ABTradingError.Create("\(methodDescription) failed. Error message: \(errorMessage)").error
                    }
                    else if let exchangeBalances = json["result","balance"].dictionary
                    {
                        log.debug("Successfully retireved \(exchangeBalances.count) account balances from \(self.name)")
                        
                        for (currency: String, balance: JSON) in exchangeBalances
                        {
                            if  let currencyCode: String = balance["currency"].string,
                                let totalStr: String = balance["amount"].string,
                                let frozenStr: String = json["result","frozen",currency,"amount"].string
                            {
                                // get currency object from Currency Manager
                                if let currencyObj = CurrencyManager.sharedCurrencyManager.find(currencyCode)
                                {
                                    var newBalance = Balance(asset: currencyObj)
                                    
                                    newBalance.total = (totalStr as NSString).doubleValue
                                    
                                    let frozen: Double = (frozenStr as NSString).doubleValue
                                    
                                    // available amount = total amount - frozen amount
                                    newBalance.available = newBalance.total - frozen
                                    
                                    newBalances.append(newBalance)
                                }
                                else
                                {
                                    returnError = ABTradingError.Create("\(methodDescription) failed. Currency \(currencyCode) has not been configured. Amout could not be parsed form the balance json object. Or result.frozen.amount could not be parsed").error
                                    
//                                    log.error("parse error from currency " + balance["currency"].error!.description)
//                                    log.error("parse error from amount " + balance["amount"].error!.description)
                                    log.error("parse error from result.frozen.currency.amount " + balance["result","frozen",currency,"amount"].error!.description)
                                }
                            }
                            else
                            {
                                returnError = ABTradingError.Create("\(methodDescription) failed. Could not parse the currency, amount in balance JSON:\n\(balance.description)\nOr retrieve frozen amount").error
                            }
                        }
                        
                        // add new balances to the Exchange account
                        //FIXME: need support for multiple accounts on a single exchange
                        // for now will assume there is only one account on the exchange.
                        // that is, the balances belong to the first account
                        self.accounts.first?.balances = newBalances
                    }
                    else
                    {
                        returnError = ABTradingError.Create("\(methodDescription) failed. Could not parse JSON array: \(json.description)").error
                    }
                }
                else
                {
                    returnError = ABTradingError.Create("\(methodDescription) failed. No JSON data was returned").error
                }
                
                if let error = returnError {
                    log.error(error.debugDescription)
                }
                
                completionHandler(balances: newBalances, error: returnError)
        }
    }
}