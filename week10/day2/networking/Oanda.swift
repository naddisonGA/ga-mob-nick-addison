//
//  Oanda.swift
//  currencyConverter
//
//  Created by Nicholas Addison on 2/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
        log.debug("about to call Oanda's \(self.environment.rawValue) ticker API for \(instruments.count) instruments")
        
        Alamofire.request(OandaRouter.Tickers(instruments))
            .responseJSON {
                request, response, json, error in
                
                var tickers = [Ticker]()
                
                if let error = error
                {
                    log.error("Failed to call \(self.name) tickers API: " + error.description)
                    
                    //FIXME:- wrap Alamofire error before returning
                    completionHandler(tickers: nil, error: error)
                    return
                }
                else if let json: AnyObject = json
                {
                    let json = JSON(json)
                    
                    if let errorMessage = json["message"].string
                    {
                        let errorStr = "Failed to call \(self.name) tickers API. Error message \(errorMessage)"
                        log.error(errorStr)
                        
                        //FIXME:- wrap Alamofire error before returning
                        completionHandler(tickers: nil, error: NSError() )
                        return
                    }
                    
                    log.debug("Successfully called \(self.name) order book API. JSON: \(json.description)")
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-DDTHH:mm:ss.Z"
                    
                    if let prices = json["prices"].array
                    {
                        var index = 0
                        
                        for price in prices
                        {
                            if let timestamp = price["time"].string,
                                let ask = price["ask"].double,
                                let bid = price["bid"].double

                            {
                                let dateFromString = dateFormatter.dateFromString(timestamp)
                                
                                let newTicker = Ticker(
                                    exchange: self,
                                    instrument: instruments[index],
                                    ask: ask,
                                    bid: bid,
                                    lastPrice: nil,
                                    timestamp: dateFromString
                                )
                                
                                tickers.append(newTicker)
                            }
                            else
                            {
                                log.error("Unable to parse price object from \(self.name): " + price.description)
                                //FIXME: return a Error
                                completionHandler(tickers: nil, error: NSError() )
                                return
                            }
                            
                            index++
                        }
                    }
                    else
                    {
                        log.error("Unable to parse prices object from \(self.name). JSON: " + json.description)
                        //FIXME: return a Error
                        completionHandler(tickers: nil, error: NSError() )
                        return
                    }
                    
                }
                else
                {
                    log.error(error?.description)
                }
                
                completionHandler(tickers: tickers, error: error)
        }
    }
    
    func getTicker(instrument: Instrument, completionHandler: (ticker: Ticker?, error: NSError?) -> () )
    {
        getTickers([instrument]) {
            tickers, error in
            
            if let error = error
            {
                completionHandler(ticker: nil, error: error)
            }
            else if let ticker = tickers?.first
            {
                completionHandler(ticker: ticker, error: nil)
            }
            else
            {
                completionHandler(ticker: nil, error: nil)
            }
        }
    }
    
    func getOrderBook(instrument: Instrument, completionHandler: (orderBook: OrderBook?, error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(orderBook: nil, error: error)
    }
    
    func getTrades(instrument: Instrument, completionHandler: (trades: [Trade]?, error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(trades: nil, error: error)
    }
    
    //MARK: - private order methods
    func getBalances(completionHandler: (balances: [Balance]?, error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(balances: nil, error: error)
    }
}