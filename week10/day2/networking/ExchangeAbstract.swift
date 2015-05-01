//
//  Exchange.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// Abstract Exchange class. Generic methods on the abstract class call the delegate which is of type Exchange.
//
public class ExchangeAbstract
{
    internal var delegate: Exchange!
    
    internal init(name: String, feeChargedIn: ExchangeFeeChargedIn = .BuyAsset, commissionRates: ExchangeCommissionRates)
    {
        self.name = name
        
        self.feeChargedIn = feeChargedIn
        self.commissionRates = commissionRates
    }
    
    // unique identifier
    let name: String
    
    var markets = [Instrument : Market]()
    
    // user accounts. Note one user can have multiple accounts
    var accounts: [Account] = []
    
    var feeChargedIn: ExchangeFeeChargedIn
    
    var commissionRates: ExchangeCommissionRates
    
    // use the unique exchange name to generate a hash value
    public var hashValue: Int
    {
            return self.name.hashValue
    }
    
    public func getUniqueAssets () -> [Asset]
    {
        var assets: [Asset] = []
        
        //self.markets.map
        for (instrument, market) in self.markets
        {
            var baseAssetInList = false
            var quoteAssetInList = false
            
            // check to see if the fixed and variable assets are already in the assets list
            for asset in assets
            {
                if (asset === instrument.baseAsset)
                {
                    baseAssetInList = true
                }
                
                if (asset === instrument.quoteAsset)
                {
                    quoteAssetInList = true
                }
            }
            
            // if not already in the asset list then append
            if (!baseAssetInList)
            {
                assets.append(instrument.baseAsset)
            }
            
            if (!quoteAssetInList)
            {
                assets.append(instrument.quoteAsset)
            }
        }
        
        
        return assets
    }
}