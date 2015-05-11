//
//  Router.swift
//  currencyConverter
//
//  Created by Nicholas Addison on 2/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire
import Dollar

enum OandaEnvironment: String
{
    case Sandbox = "sandbox"
    case Practice = "practice"
    case Live = "live"
}

enum OandaRouter: URLRequestConvertible
{
    //MARK:- static variables
    
    static var environment: OandaEnvironment = .Sandbox
    static var apiKey: ApiKey?
    
    static let baseURLStrings: [OandaEnvironment: String] = [
        .Sandbox: "http://api-sandbox.oanda.com/v1/",
        .Practice: "https://api-fxpractice.oanda.com/v1/",
        .Live: "https://api-fxtrade.oanda.com/v1/"
    ]
    
    static let keychainKeyForApiKey: String = "au.com.addisonbrown.api.oanda.practice.key"
    static let keychainKeyForApiSecret: String = "au.com.addisonbrown.api.oanda.live.secret"
    
    //MARK:- enumerated cases
    
    case Tickers([Instrument])
    
    //MARK:- computed properties
    
    var method: Alamofire.Method
    {
        switch self {
        case .Tickers:
            return .GET
        }
    }
    
    var path: String
    {
        switch self {
        case .Tickers:
            return "/prices"
        }
    }
    
    // construct request object for this particular API call
    var URLRequest: NSURLRequest
    {
        // set the base url for the configured environment. eg Sandbox, Pactice or Live
        let URL = NSURL(string: OandaRouter.baseURLStrings[OandaRouter.environment]!)!
        
        // add path to base URL for this API call
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        // set the HTTP method for this API call. eg GET, POST, PUT, DELETE...
        mutableURLRequest.HTTPMethod = method.rawValue
        
        // if API key configured then add Authorization HTTP header
        if let apiKey = OandaRouter.apiKey {
            mutableURLRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        // encode parameters for this API call
        switch self {
        case .Tickers(let instruments):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: getInstrumentParameters(instruments) ).0
        default:
            return mutableURLRequest
        }
    }
    
    func getInstrumentParameters(instruments: [Instrument]) -> [String: String]
    {
        //if instruments.count == 0 { return ["instruments": ""] }
        
        var instrumentCodes: String = ""
        for instrument in instruments
        {
            // append insturment code in upper case speatated by an underscore. eg AUD_USD
            instrumentCodes += "," + instrument.code(.UnderscoreUpperCase)
        }
        
        if instruments.count > 0
        {
            // remove the leading comma
            instrumentCodes = instrumentCodes.substringFromIndex(advance(instrumentCodes.startIndex, 1))
        }
        
        return ["instruments": instrumentCodes]
    }
}