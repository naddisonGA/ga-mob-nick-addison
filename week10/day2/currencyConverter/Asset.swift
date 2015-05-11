//
//  Asset.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation


// this is a global function to test if two Assets are the same
public func ==(lhs: Asset, rhs: Asset) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

// represents a tradable asset that can be bought and sold. For example, a currency, share, bond, derivative or commodity
public class Asset : Hashable
{
    // code is the unique identify of the asset. eg AUD for currency or BHP for share
    // Not a share like BHP is also an instrument that can be traded on multiple exchanges.
    // BHP traded on ASX (ASXBHP) is a market as it's made up of an instrument and an exchange.
    public let code: String
    
    public var hashValue: Int {
        return self.code.hashValue
    }
    
    // description of the asset. eg Australian Dollar or Westpac Banking Corporation
    public let name: String
    
    //MARK: - initializers
    
    init (code: String, name: String)
    {
        self.code = code
        self.name = name
    }
}