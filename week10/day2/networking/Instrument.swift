//
//  Instrument.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

public func ==(lhs: Instrument, rhs: Instrument) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public enum InstrumentCodeFormat
{
    case LowerCase
    case UpperCase
    case UnderscoreLowerCase
    case UnderscoreUpperCase
}

// is a pair of assets that can be traded. eg AUDEUR or BTCUSD
public class Instrument: Hashable
{
    // the base or fixed currency. eg AUD in AUDUSD
    public let baseAsset: Asset
    
    // the quote or variable currency. eg USD in AUDUSD
    public let quoteAsset: Asset
    
    public var hashValue: Int {
        return code(.UpperCase).hashValue
    }
    
    // MARK: - initializer
    
    init (base: Asset, quote: Asset)
    {
        self.baseAsset = base
        self.quoteAsset = quote
    }
    
    func code(format: InstrumentCodeFormat) -> String
    {
        switch format
        {
        case .LowerCase:
            return baseAsset.code.lowercaseString + quoteAsset.code.lowercaseString
            
        case .UpperCase:
            return baseAsset.code.uppercaseString + quoteAsset.code.uppercaseString
            
        case .UnderscoreLowerCase:
            return baseAsset.code.lowercaseString + "_" + quoteAsset.code.lowercaseString
            
        case .UnderscoreUpperCase:
            return baseAsset.code.uppercaseString + "_" + quoteAsset.code.uppercaseString
        }
    }
    
    var codeUnderscoreUpperCase: String {
        return code(.UnderscoreUpperCase)
    }
}