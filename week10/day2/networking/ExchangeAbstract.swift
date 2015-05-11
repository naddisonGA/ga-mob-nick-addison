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
    
    internal init(
        name: String,
        feeChargedIn: ExchangeFeeChargedIn = .BuyAsset,
        commissionRates: ExchangeCommissionRates)
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
    
    /// set api key and secret from the Keychain
    func setApiKeysFromKeychain()
    {
        if  let apiKey = Keychain.get(self.delegate.keychainKeyForApiKey),
            let apiSecret = Keychain.get(self.delegate.keychainKeyForApiSecret)
        {
            self.delegate.setKeyOnRouter(apiKey, apiSecret: apiSecret)
        }
        else
        {
            log.error("\(self.name) API key and/ or secret could not be retreived from the Keychain using keys \(self.delegate.keychainKeyForApiKey) and \(self.delegate.keychainKeyForApiSecret)")
        }
    }
    
    
//    func getTickers (instruments: [Instrument], callback: (tickers: [Ticker]?, error: NSError?) -> () )
//    {
//        var returnedTickers = [Ticker]()
//        var returnedError: NSError? = nil
//        
//        for instrument in instruments
//        {
//            delegate.getTicker(instrument) {
//                (ticker, error) in
//                
//                // if have not already returned an error
//                if returnedError != nil
//                {
//                    // if an error was returned for this ticker
//                    if error != nil
//                    {
//                        callback(tickers: nil, error: error)
//                    }
//                    // if a ticker was successfully returned
//                    else if let ticker = ticker
//                    {
//                        // add to the array of tickers to be returned for the array of instruments
//                        returnedTickers.append(ticker)
//                        
//                        // if all the tickers have been returned for the instruments
//                        if returnedTickers.count == instruments.count
//                        {
//                            // pass back the array of tickers in the callback
//                            callback(tickers: returnedTickers, error: error)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    // a genric implementation that loops through each instrument calling getTicker in parallel
    // once all the tickers have been received they are passed back through the callback
    // if any getTicker calls return an error the error is passed bcack through the callback.
    // Only the first error is returned if there are multiple errors. That is, the callback is only called once
    func getTickers (instruments: [Instrument], completionHandler: (tickers: [Ticker]?, error: NSError?) -> () )
    {
        func iterator(instrument: Instrument, iteratorCompletionHandler: (ticker: Ticker?, error: NSError?) -> () ) -> ()
        {
            self.delegate.getTicker(instrument) {
                (ticker, error) in
                
                iteratorCompletionHandler(ticker: ticker, error: error)
            }
        }
        
        Async.each(instruments, iterator: iterator, completionHandler: completionHandler)
    }
    
    // a genric implementation that loops through each instrument calling getOrderBook in parallel
    func getOrderBooks(instruments: [Instrument], completionHandler: (orderBooks: [OrderBook]?, error: NSError?) -> () )
    {
        func iterator(instrument: Instrument, iteratorCompletionHandler: (orderBook: OrderBook?, error: NSError?) -> () ) -> ()
        {
            self.delegate.getOrderBook(instrument) {
                (orderBook, error) in
                
                iteratorCompletionHandler(orderBook: orderBook, error: error)
            }
        }
        
        Async.each(instruments, iterator: iterator, completionHandler: completionHandler)
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