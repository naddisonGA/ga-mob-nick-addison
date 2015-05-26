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

class Bitfinex : ExchangeAbstract, Exchange
{
    //MARK:- class constants
    
    let keychainKeyForApiKey: String = "au.com.addisonbrown.api.bitfinex.key"
    let keychainKeyForApiSecret: String = "au.com.addisonbrown.api.bitfinex.secret"
    
    //MARK:- initializers
    
    init (
        name: String,
        instruments: [Instrument],
        commissionRates: ExchangeCommissionRates,
        feeChargedIn: ExchangeFeeChargedIn = .BuyAsset,
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
        
        setApiKeysFromKeychain()
    }
    
    /// sets the API key and secret stored in the Keychain
    func setKeyOnRouter(apiKey: String, apiSecret: String?) -> ()
    {
        BitfinexRouter.apiKey = ApiKey(key: apiKey, secret: apiSecret)
    }
    
    //MARK: - public market data methods
    
    func getTicker(instrument: Instrument, completionHandler: (ticker: Ticker?, error: NSError?) -> () )
    {
        let methodDescription = "\(self.name) Ticker API for \(instrument.code(.UpperCase))"
        
        log.debug("About to call \(methodDescription)")
        
        var returnError: NSError? = nil
        var newTicker: Ticker? = nil
        
        Alamofire.request(BitfinexRouter.Ticker(instrument))
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
                    
                    if  let askStr = json["ask"].string,
                        let bidStr = json["bid"].string,
                        let lastPriceStr = json["last_price"].string,
                        let timestampStr = json["timestamp"].string
                    {
                        let timestamp: NSTimeInterval = (timestampStr as NSString).doubleValue
                        
                        newTicker = Ticker(
                            exchange: self as Exchange,
                            instrument: instrument,
                            ask: (askStr as NSString).doubleValue,
                            bid: (bidStr as NSString).doubleValue,
                            lastPrice: (lastPriceStr as NSString).doubleValue,
                            timestamp: NSDate(timeIntervalSince1970: timestamp)
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
        
        Alamofire.request(BitfinexRouter.OrderBook(instrument))
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
            if  let price = order["price"].string,
                let quantity =  order["amount"].string
            {
                // add converted order to the array that will be returned
                convertedOrders.append(OrderBookOrder(
                    price: (price as NSString).doubleValue,
                    quantity: (quantity as NSString).doubleValue
                    ))
            }
            else
            {
                error = ABTradingError.Create("Could not parse price or amount in order.\nJSON:\n\(order)").error
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
        
        Alamofire.request(BitfinexRouter.Balances())
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
                    else if let exchangeBalances = json.array
                    {
                        log.debug("Successfully retireved \(exchangeBalances.count) account balances from \(self.name)")
                        
                        for balance in exchangeBalances
                        {
                            if  let currencyCode: String = balance["currency"].string?.uppercaseString,
                                let walletType: String = balance["type"].string
                            {
                                // continue to next loop if wallet type is trading or deposit
                                //TODO: this needs to loop through each wallet/account
                                if walletType != "exchange" { continue }
                                
                                if let currency = CurrencyManager.sharedCurrencyManager.find(currencyCode)
                                {
                                    var newBalance = Balance(asset: currency)
                                    
                                    if let total: String = balance["amount"].string,
                                        let available: String = balance["available"].string
                                    {
                                        newBalance.total = (total as NSString).doubleValue
                                        newBalance.available = (available as NSString).doubleValue
                                        
                                        newBalances.append(newBalance)
                                    }
                                    else
                                    {
                                        returnError = ABTradingError.Create("\(methodDescription) failed. Could not parse the amount and/or available fields in balance JSON:n\(balance.description)").error
                                    }
                                }
                                else
                                {
                                    returnError = ABTradingError.Create("\(methodDescription) failed. Currency \(currencyCode) has not been configured").error
                                }
                            }
                            else
                            {
                                returnError = ABTradingError.Create("\(methodDescription) failed. Could not parse the currency and/or type field in balance JSON:\n\(balance.description)").error
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