//
//  BTCMarketsRouter.swift
//  networking
//
//  Created by Nicholas Addison on 3/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire

class OrderIds
{
    var orderIds: [Int]
    
    init (orderIds: [Int])
    {
        self.orderIds = orderIds
    }
}

// Implementation of the BTC Markets bitcoin exchange REST API
// https://github.com/BTCMarkets/API

enum BTCMarketsRouter: URLRequestConvertible
{
    //MARK:- static variables
    
    static var baseURLString = "https://api.btcmarkets.net/"
    
    static var apiKey: ApiKey?
    
    static let signer = HMAC(algorithm: .SHA512, secretDecoding: .Base64, messageEncoding: .UTF8, digestEncoding: .Base64)
    
    //MARK:- enumerated cases
    
    case Ticker(Instrument)
    case OrderBook(Instrument)
    case Trades(Instrument)
    case Balances()
    case OrderDetail([Int])
    
    //MARK:- computed properties
    
    var method: Alamofire.Method
        {
            switch self {
            case .Ticker, .OrderBook, .Trades, .Balances:
                return .GET
            default:
                return .POST
            }
    }
    
    var authorization: Bool
        {
            switch self {
            case .Ticker, .OrderBook, .Trades:
                return false
            default:
                return true
            }
    }
    
    func marketPath(instrument: Instrument, action: String) -> String
    {
        return "/market/" + instrument.baseAsset.code + "/" + instrument.quoteAsset.code + "/" + action
    }
    
    var path: String
        {
            switch self {
            case .Ticker(let instrument):
                return marketPath(instrument, action: "tick")
                
            case .OrderBook(let instrument):
                return marketPath(instrument, action: "orderbook")
                
            case .Trades(let instrument):
                return marketPath(instrument, action: "trades")
                
            case .Balances:
                return "/account/balance"
                
            case .OrderDetail(let orderIds):
                return "/order/detail"
            }
    }
    
    var timestamp: String
    {
        // milliseconds since 1970
        // timeIntervalSince1970 is a Double so need to convert to a String
        return String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000)
    }
    
    var message: String
    {
        var messageBase = path + "\n" + timestamp + "\n"
        
        switch self {
        case .OrderDetail(let orderIds):
            //TODO: refactor with SwiftyJSON
            
            let orderIdsObject: AnyObject = OrderIds(orderIds: orderIds)
            
            if let jsonData: NSData = NSJSONSerialization.dataWithJSONObject(orderIdsObject, options: nil, error: nil)
            {
                if let jsonString =  NSString(data: jsonData, encoding: NSUTF8StringEncoding)
                {
                    return messageBase + (jsonString as String)
                }
            }
            return messageBase
            
        default:
            return messageBase
        }
        
    }
    
    // construct request object for this particular API call
    var URLRequest: NSURLRequest
        {
            // set the base url for the configured environment. eg Sandbox, Pactice or Live
            let URL = NSURL(string: BTCMarketsRouter.baseURLString)!
            
            // add path to base URL for this API call
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            
            // set the HTTP method for this API call. eg GET, POST, PUT, DELETE...
            mutableURLRequest.HTTPMethod = method.rawValue
            
            mutableURLRequest.setValue("BTC Markets Swift API Client", forHTTPHeaderField: "User-Agent")
            
            // if Authorization HTTP header
            if authorization
            {
                mutableURLRequest.setValue(BTCMarketsRouter.apiKey!.key, forHTTPHeaderField: "apikey")
                
                mutableURLRequest.setValue(timestamp, forHTTPHeaderField: "timestamp")
                
                if let signature: String = BTCMarketsRouter.signer.createDigest(message, secretStr: BTCMarketsRouter.apiKey!.secret!)
                {
                    mutableURLRequest.setValue(signature, forHTTPHeaderField: "signature")
                    
                    log.debug("\napikey: \(BTCMarketsRouter.apiKey!.key)\ntimestamp: \(self.timestamp)\nsignature: \(signature)")
                }
            }
            
            // encode parameters for this API call
            switch self {
            default:
                return mutableURLRequest
            }
    }
}