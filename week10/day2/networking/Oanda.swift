//
//  Oanda.swift
//  currencyConverter
//
//  Created by Nicholas Addison on 2/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire

class Oanda: ExchangeAbstract, Exchange
{
    init(name: String, feeChargedIn: ExchangeFeeChargedIn, commissionRates: ExchangeCommissionRates, environment: OandaEnvironment)
    {
        self.environment = environment
        super.init(name: name, feeChargedIn: feeChargedIn, commissionRates: commissionRates)
    }
    
    var environment: OandaEnvironment {
        didSet {
            OandaRouter.environment = environment
            
            self.setApiKeysFromKeychain()
        }
    }
    
    var keychainKeyForApiKey: String {
        // append environment to the end of the Keychain key. eg append .practice or .live
        return "au.com.addisonbrown.api.oanda.key." + environment.rawValue
    }
    let keychainKeyForApiSecret = ""
    
    override func setApiKeysFromKeychain()
    {
        // there is no API key for the Sandbox environment
        if environment == .Sandbox
        {
            self.setKeyOnRouter("", apiSecret: nil)
            return
        }
        
        // append environment to the end of the Keychain key. eg append .practice or .live
        //let envKeychainKeyForApiKey = keychainKeyForApiKey + "." + environment.rawValue
        
        if  let apiKey = Keychain.get(keychainKeyForApiKey)
        {
            self.setKeyOnRouter(apiKey, apiSecret: nil)
        }
        else
        {
            log.error("\(self.name) API key could not be retreived from the Keychain using key \(self.keychainKeyForApiKey)")
        }
    }
    
    /// sets the API key and secret stored in the Keychain
    func setKeyOnRouter(apiKey: String, apiSecret: String?) -> ()
    {
        OandaRouter.apiKey = ApiKey(key: apiKey, secret: apiSecret)
    }
    
    override func getTickers (instruments: [Instrument], completionHandler: (tickers: [Ticker]?, error: NSError?) -> () )
    {
        log.debug("about to call Oanda's \(self.environment.rawValue) prices API")
        
        Alamofire.request(OandaRouter.Tickers(instruments))
            .responseJSON { (request, response, json, error) -> Void in
                
                var tickers = [Ticker]()
                
                if error != nil
                {
                    completionHandler(tickers: nil, error: error)
                }
                else if json != nil
                {
                    log.debug("Successfully called Oanda's \(self.environment.rawValue) price API. JSON response: \(json!)")
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-DDTHH:mm:ss.Z"
                    
                    for price in json!.valueForKey("prices") as! [AnyObject]
                    {
                        let dateFromString = dateFormatter.dateFromString(price.valueForKey("time") as! String)
                        
                        let newTicker = Ticker(
                            exchange: self,
                            instrument: instruments.first!,
                            ask: price.valueForKey("ask") as! Double,
                            bid: price.valueForKey("bid") as! Double,
                            lastPrice: nil,
                            timestamp: dateFromString
                        )
                        
                        tickers.append(newTicker)
                    }
                }
                else
                {
                    log.error(error?.description)
                }
                
                completionHandler(tickers: tickers, error: error)
        }
    }
    
    func getTicker(instrument: Instrument, callback: (ticker: Ticker?, error: NSError?) -> () )
    {
        getTickers([instrument]) {
            (tickers, error) in
            if let error = error
            {
                callback(ticker: nil, error: error)
            }
            else if let ticker = tickers?.first
            {
                callback(ticker: ticker, error: nil)
            }
            else
            {
                callback(ticker: nil, error: nil)
            }
        }
    }
    
    func getOrderBook(instrument: Instrument, callback: (orderBook: OrderBook?, error: NSError?) -> () ) {}
    
    func getTrades(instrument: Instrument, callback: (trades: [Trade]?, error: NSError?) -> () ) {}
    
    //MARK: - private order methods
    
    func getBalances(callback: (balances: [Balance]?, error: NSError?) -> () ) {}
    
    func addOrder(newOrder: Order, callback: (exchangeOrder: Order?, error: NSError?) -> () ) {}
    
    func cancelOrder(oldOrder: Order, callback: (error: NSError?) -> () ) {}
    
    func getOrder(exchangeId: String, callback: (exchangeOrder: Order?, error: NSError?) -> () ) {}
    
    func getOpenOrders(instrument: Instrument, callback: (exchangeOrder: Order?, error: NSError?) -> () ) {}
}