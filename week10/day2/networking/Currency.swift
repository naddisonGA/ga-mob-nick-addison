//
//  Currency.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// An implementation of an asset
// Represents both fiat currencies like Australian (AUD) and United States Dollars (USD)
// as well as crypto currency assets like Bitcoin (BTC) and Litecoin (LTC)
public class Currency: Asset
{
    // the number of decimal places of the currency.
    public let percision: Int
    
    // MARK: - initializer
    
    init(code: String, name: String, percision: Int = 2)
    {
        self.percision = percision
        super.init(code: code, name: name)
    }
}