//
//  Bitfinex.swift
//  networking
//
//  Created by Nicholas Addison on 3/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire
import Dollar

// Implementation of the Independent Reserve Bitcoin exchange REST API
// https://www.independentreserve.com/API

enum IndependentReserveRouter: URLRequestConvertible
{
    //MARK:- static variables
    
    static var apiKey: ApiKey?
    
    //MARK:- static constants
    
    static let baseURLString = "https://api.independentreserve.com"
    //static let baseURLString = "http://dev.api.independentreserve.com"
    
    static let userAgent = "Independent Reserve Swift API Client"
    static let signer = HMAC(algorithm: .SHA256, secretDecoding: .UTF8, messageEncoding: .UTF8, digestEncoding: .Hex)
    
    //MARK:- enumerated cases
    
    case Ticker(Instrument)
    case OrderBook(Instrument)
    case Trades(Instrument)
    case Balances()
    case OrderDetail(Int)
    
    //MARK:- computed properties
    
    var method: Alamofire.Method
    {
        switch self {
        case .Ticker, .OrderBook, .Trades:
            return .GET
        default:
            return .POST
        }
    }
    
    var path: String
    {
        switch self {
        case .Ticker(let instrument):
            return "/Public/GetMarketSummary"
            
        case .OrderBook(let instrument):
            return "/Public/GetOrderBook"
            
        case .Trades(let instrument):
            return "/Public/GetRecentTrades"
            
        case .Balances:
            return "/Private/GetAccounts"
            
        case .OrderDetail:
            return "/Private/GetOrderDetails"
        }
    }
    
    var url: String
    {
        return IndependentReserveRouter.baseURLString + path
    }
    
    // initialize nonce to unix time. ie number of seconds since 1970
    static var nonce = Int(NSDate().timeIntervalSince1970)
    
    var commonParameters: [String: AnyObject]
        {
            return [
                "apiKey": IndependentReserveRouter.apiKey!.key,
                "nonce": IndependentReserveRouter.nonce
            ]
    }
    
    var parameters: [String: AnyObject]
    {
        var parameters = commonParameters
        
        // add API specific parameters
        switch self {
        case OrderDetail(let orderGuid):
            parameters["orderGuid"] = orderGuid
        default:
            break
        }
        
        return parameters
    }
    
    //  message is comma-separated string containing the API method URL, and a comma separated list of all method parameters (except signature) in the form: "parameterName=parameterValue".
    var message: String
    {
        var messageStr = "\(url)"
        
        var messageParameters = $.merge(commonParameters, parameters)
        
        for (key, value) in messageParameters
        {
            messageStr += ",\(key)=\(value)"
        }
        
        log.debug("message string to be encrypted:" + messageStr)
        
        return messageStr
    }
    
    var bodyParameters: [String: AnyObject]?
    {
        if method != .POST { return nil }
        
        // generate signature
        if let signature = IndependentReserveRouter.signer.createDigest(message, secretStr: IndependentReserveRouter.apiKey!.secret!)
        {
            // merge common parameters, signatature and the specific API parameters
            return $.merge(commonParameters, ["signature": signature], parameters)
        }
        else
        {
            log.error("Failed to encrypt message \(self.message) with secret")
            return nil
        }
    }
    
    var urlParameters: [String: AnyObject]?
    {
        if method != .GET { return nil }
        
        switch self {
        case Ticker(let instrument):
            return [
                //FIXME: change hard coded xbt to a transformation of BTC to xbt
                "primaryCurrencyCode": "xbt",
                "secondaryCurrencyCode": instrument.quoteAsset.code.lowercaseString ]
        default:
            return nil
        }
    }
    
    // construct request object for this particular API call
    var URLRequest: NSURLRequest
    {
        // set the base url for the configured environment. eg Sandbox, Pactice or Live
        let URL = NSURL(string: IndependentReserveRouter.baseURLString)!
        
        // add path to base URL for this API call
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        // set the HTTP method for this API call. eg GET, POST, PUT, DELETE...
        mutableURLRequest.HTTPMethod = method.rawValue
        
        log.debug("\(self.method.rawValue) request to \(self.url)")
        
        mutableURLRequest.setValue(BitfinexRouter.userAgent, forHTTPHeaderField: "User-Agent")
        
        // if API key configured then add Authorization HTTP header
        if method == .POST,
            let bodyParameters = bodyParameters
        {
            IndependentReserveRouter.nonce++
            
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: bodyParameters).0
        }
        else if method == .GET,
            let urlParameters = urlParameters
        {
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: urlParameters).0
        }
        
        return mutableURLRequest
    }
}