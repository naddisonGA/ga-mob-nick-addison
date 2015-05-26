//
//  BTCChinaRouter.swift
//  networking
//
//  Created by Nicholas Addison on 3/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire

// Implementation of the BTC China Bitcoin exchange REST API
// http://btcchina.org/api-trade-documentation-en

enum BTCChinaRouter: URLRequestConvertible
{
    //MARK:- static variables
    
    static var apiKey: ApiKey?
    
    //MARK:- static constants
    
    static let userAgent = "BTC China Swift API Client"
    static let id = 1
    
    static let signer = HMAC(algorithm: .SHA1, secretDecoding: .UTF8, messageEncoding: .UTF8, digestEncoding: .Hex)
    
    //MARK:- enumerated cases
    
    case Ticker(Instrument)
    case OrderBook(Instrument)
    case Trades(Instrument)
    case Balances()
    case OrderDetail(Int)
    
    //MARK:- computed properties
    
    var baseURLString: String
    {
        switch self {
        case .Trades:
            return "https://data.btcchina.com"
        default:
            return "https://api.btcchina.com"
        }
    }
    
    var requestMethod: Alamofire.Method
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
            return "/data/ticker"
            
        case .OrderBook(let instrument):
            return "/data/orderbook"
            
        case .Trades(let instrument):
            return "/data/historydata"
            
        default:
            return "/api_trade_v1.php"
        }
    }
    
    static var _tonce:Double = NSDate().timeIntervalSince1970 * 1000000
    
    var tonce: String {
        return String(format: "%.0f", BTCChinaRouter._tonce)
    }
    
    func updateTonce()
    {
        BTCChinaRouter._tonce = NSDate().timeIntervalSince1970 * 1000000
    }
    
    var message: String
    {
        if let apiKey = BTCChinaRouter.apiKey?.key
        {
            let messageStr =
                "tonce=\(tonce)&" +
                "accesskey=\(apiKey)&" +
                "requestmethod=\(requestMethod.rawValue.lowercaseString)&" +
                "id=\(BTCChinaRouter.id)&" +
                "method=\(method)&" +
                "params=\(paramStr)"
            
            log.debug(messageStr)
            
            return messageStr
        }
        
        log.error("Could not find BTC China API key")
        
        return ""
    }
    
    var paramStr: String
    {
        var paramArray = [AnyObject]()
        
        switch self {
        case OrderDetail(let orderId):
            paramArray = [orderId]
            
        default:
            return ""
        }
        
        // convert parameters array to JSON string
        if  NSJSONSerialization.isValidJSONObject(paramArray),
            let jsonData = NSJSONSerialization.dataWithJSONObject(paramArray, options: nil, error: nil),
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
        {
            return jsonString as String
        }
        else
        {
            return ""
        }
        
    }
    
    var method: String
    {
        switch self {
        case .Balances():
            return "getAccountInfo"
            
        case OrderDetail(let orderId):
            return "getOrder"
            
        default:
            return ""
        }
    }
    
    // Basic authorisation using base64 encoded key:digest
    // See the following for more details
    // http://btcchina.org/api-trade-documentation-en#guide_to_authenticate_api_access
    func authorisationHeader(digest: String) -> String
    {
        // get API key
        if let key = BTCChinaRouter.apiKey?.key
        {
            // String of key and digest separated by a colon
            let keyDigestPair: String = "\(key):\(digest)"
            
            // Base64 encode key and digest string
            if let hash: String = BinaryEncoding.Base64.encode(keyDigestPair)
            {
                return "Basic \(hash)"
            }
        }
        
        log.debug("Can't construct authorisation header. BTC China API key has not been set.")
        
        return ""
    }
    
    var bodyParameters: [String: AnyObject]?
    {
        if requestMethod != .POST { return nil }
        
        return [
            "method": method,
            "params": [],
            "id": BTCChinaRouter.id]
    }
    
    // construct request object for this particular API call
    var URLRequest: NSURLRequest
    {
        // set the base url for the configured environment. eg Sandbox, Pactice or Live
        let URL = NSURL(string: baseURLString)!
        
        // add path to base URL for this API call
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        // set the HTTP method for this API call. eg GET, POST, PUT, DELETE...
        mutableURLRequest.HTTPMethod = requestMethod.rawValue
        
        log.debug("\(self.requestMethod.rawValue) request to url \(URL.absoluteString!)")
        
        mutableURLRequest.setValue(BTCChinaRouter.userAgent, forHTTPHeaderField: "User-Agent")
        
        // if API key configured then add Authorization HTTP header
        if requestMethod == .POST
        {
            // update the tonce value before it is needed in the encrypted message and parameters in the json body
            updateTonce()
            
            mutableURLRequest.setValue(tonce, forHTTPHeaderField: "Json-Rpc-Tonce")
            
            log.debug("tonce: \(self.tonce)")
            
            if let digest = BTCChinaRouter.signer.createDigest(message, secretStr: BTCChinaRouter.apiKey!.secret!)
            {
                mutableURLRequest.setValue(authorisationHeader(digest), forHTTPHeaderField: "Authorization")
            }
            else
            {
                log.error("Failed to encrypt message \(self.message)")
            }
            
            // if API key configured then add Authorization HTTP header
            if let bodyParameters = bodyParameters
            {
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: bodyParameters).0
            }
        }
        
        return mutableURLRequest
    }
}