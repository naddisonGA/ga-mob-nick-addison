//
//  Bitfinex.swift
//  networking
//
//  Created by Nicholas Addison on 3/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire

// Implementation of the Bitfinex Bitcoin exchange REST API
// https://www.bitfinex.com/pages/api

enum BitfinexRouter: URLRequestConvertible
{
    //MARK:- static variables
    
    static var apiKey: ApiKey?
    
    //MARK:- static constants
    
    static let baseURLString = "https://api.bitfinex.com"
    static let version = "/v1/"
    static let userAgent = "Bitfinex Swift API Client"
    static let signer = HMAC(algorithm: .SHA384, secretEncoding: .UTF8, messageEncoding: .Base64, digestEncoding: .Hex)
    
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
        return BitfinexRouter.version + action + "/" + instrument.code(.LowerCase)
    }
    
    var path: String
        {
            switch self {
            case .Ticker(let instrument):
                return marketPath(instrument, action: "pubticker")
                
            case .OrderBook(let instrument):
                return marketPath(instrument, action: "book")
                
            case .Trades(let instrument):
                return marketPath(instrument, action: "trades")
                
            case .Balances:
                return BitfinexRouter.version + "balances"
                
            case .OrderDetail:
                return BitfinexRouter.version + "order/status"
            }
    }
    
    static var _nonce: Double = NSDate().timeIntervalSince1970
    
    var nonce: String
    {
        return String(format: "%.0f", BitfinexRouter._nonce)
    }
    
    var message: String
    {
        var payload: Dictionary<String, AnyObject> = [
            "request": path,
            "nonce": nonce
        ]
            
        // add any API parameters to the payload
        switch self {
        case OrderDetail(let orderId):
            payload["order_id"] = orderId
        default:
            break
        }
            
        // convert payload object to JSON string
        if  NSJSONSerialization.isValidJSONObject(payload),
            let jsonData = NSJSONSerialization.dataWithJSONObject(payload, options: nil, error: nil),
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
        {
            return jsonString as String
        }
        else
        {
            return ""
        }
    }
    
    // construct request object for this particular API call
    var URLRequest: NSURLRequest
        {
            // set the base url for the configured environment. eg Sandbox, Pactice or Live
            let URL = NSURL(string: BitfinexRouter.baseURLString)!
            
            // add path to base URL for this API call
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            
            // set the HTTP method for this API call. eg GET, POST, PUT, DELETE...
            mutableURLRequest.HTTPMethod = method.rawValue

            log.debug("\(self.method.rawValue) request to url \(URL.absoluteString!)")
            
            mutableURLRequest.setValue(BitfinexRouter.userAgent, forHTTPHeaderField: "User-Agent")
            
            log.debug("\nkey: \(BitfinexRouter.apiKey!.key)\nmessage: \(self.message)\nsecret: \(BitfinexRouter.apiKey!.secret)")
            
            // if API key configured then add Authorization HTTP header
            if authorization
            {
                mutableURLRequest.setValue(BitfinexRouter.apiKey!.key, forHTTPHeaderField: "X-BFX-APIKEY")
                
                if let signature = BitfinexRouter.signer.createDigest(message, secretStr: BitfinexRouter.apiKey!.secret!)
                {
                    mutableURLRequest.setValue(signature, forHTTPHeaderField: "X-BFX-SIGNATURE")
                    
                    log.debug("signature: \(signature)")
                }
                else
                {
                    log.error("Failed to encrypt message \(self.message) with secret")
                }
                
                // payload is the message base64 encoded
                if let payload: String = BinaryEncoding.Base64.encode(message)
                {
                    mutableURLRequest.setValue(payload, forHTTPHeaderField: "X-BFX-PAYLOAD")
                    
                    log.debug("payload: \(payload)")
                }
                else
                {
                    log.error("Failed to base64 encode message \(self.message)")
                }
                
                BitfinexRouter._nonce++
            }
            
            return mutableURLRequest
    }
}