//
//  Exchange.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

public enum ExchangeFeeChargedIn
{
    case BuyAsset
    case SellAsset
    case BaseAsset
    case QuoteAsset
}

public struct ExchangeCommissionRates
{
    let maker: [Asset: Double]
    let taker: [Asset: Double]
    
    init (makerRates: [Asset: Double], takerRates: [Asset: Double])
    {
        self.maker = makerRates
        self.taker = takerRates
    }
    
    init (rates: [Asset: Double])
    {
        self.maker = rates
        self.taker = rates
    }
}

public func ==(lhs: Exchange, rhs: Exchange) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

// an entity which multiple instruments can be traded
public class Exchange: Hashable
{
    // unique identifier
    public let name: String
    
    public let markets: [Instrument : Market]
    
    // user accounts. Note one user can have multiple accounts
    public var accounts: [Account] = []
    
    public let feeChargedIn: ExchangeFeeChargedIn
    
    public let commissionRates: ExchangeCommissionRates
    
    init (name: String, instruments: [Instrument], feeChargedIn: ExchangeFeeChargedIn = .BuyAsset, commissionRates: ExchangeCommissionRates)
    {
        self.name = name
        
        self.feeChargedIn = feeChargedIn
        self.commissionRates = commissionRates
        
        // initialise to an empty dictionary
        self.markets = [Instrument : Market]()
        
        // for each instrument
        for instrument in instruments
        {
            // create a new market for this new exchange and instrument
            // and add to the markets dictionary
            self.markets[instrument] = Market(exchange: self, instrument: instrument)
        }
    }
    
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