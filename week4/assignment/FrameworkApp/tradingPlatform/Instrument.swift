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

// is a pair of assets that can be traded. eg AUDEUR or BTCUSD
public class Instrument: Asset, Hashable
{
    // the base or fixed currency. eg AUD in AUDUSD
    public let baseAsset: Asset
    
    // the quote or variable currency. eg USD in AUDUSD
    public let quoteAsset: Asset
    
    // MARK: - initializer
    
    init (base: Asset, quote: Asset)
    {
        self.baseAsset = base
        self.quoteAsset = quote
        
        super.init(code: "\(base.code)_\(quote.code)", name: "base asset \(base), quote asset \(quote)")
    }
}