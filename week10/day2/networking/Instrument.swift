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

let AUDUSD = Instrument(base: AUD, quote: USD)
let USDAUD = Instrument(base: USD, quote: AUD)
let AUDCNY = Instrument(base: AUD, quote: CNY)
let CNYAUD = Instrument(base: CNY, quote: AUD)
let USDCNY = Instrument(base: USD, quote: CNY)
let CNYUSD = Instrument(base: CNY, quote: USD)
let USDCNH = Instrument(base: USD, quote: CNH)
let BTCAUD = Instrument(base: BTC, quote: AUD)
let BTCUSD = Instrument(base: BTC, quote: USD)
let BTCCNY = Instrument(base: BTC, quote: CNY)
let LTCAUD = Instrument(base: LTC, quote: AUD)
let LTCUSD = Instrument(base: LTC, quote: USD)
let LTCBTC = Instrument(base: LTC, quote: BTC)
let DRKUSD = Instrument(base: DRK, quote: USD)
let DRKAUD = Instrument(base: DRK, quote: AUD)
