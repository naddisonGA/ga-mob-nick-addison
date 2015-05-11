//
//  Currency.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

public enum CurrencyTyoe
{
    case Fiat
    case Crypto
}

// An implementation of an asset
// Represents both fiat currencies like Australian (AUD) and United States Dollars (USD)
// as well as crypto currency assets like Bitcoin (BTC) and Litecoin (LTC)
public class Currency: Asset
{
    // the number of decimal places of the currency.
    public let percision: Int
    
    public let type: CurrencyTyoe
    
    // MARK: - initializer
    
    init(code: String, name: String, type: CurrencyTyoe, percision: Int = 2)
    {
        self.type = type
        self.percision = percision
        super.init(code: code, name: name)
    }
}