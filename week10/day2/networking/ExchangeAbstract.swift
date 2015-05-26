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
    //MARK:- to be set to the instance of the subclass
    var delegate: Exchange!
    
    //MARK:- Initialized properties
    
    // unique identifier
    public let name: String
    
    public var feeChargedIn: ExchangeFeeChargedIn
    
    public var commissionRates: ExchangeCommissionRates
    
    init(
        name: String,
        feeChargedIn: ExchangeFeeChargedIn = .BuyAsset,
        commissionRates: ExchangeCommissionRates)
    {
        self.name = name
        
        self.feeChargedIn = feeChargedIn
        self.commissionRates = commissionRates
    }
    
    //MARK:- Optional properties
    
    public var markets = [Instrument : Market]()
    
    // user accounts. Note one user can have multiple accounts
    public var accounts = [Account]()
    
    //MARK:- Computed properties
    
    // use the unique exchange name to generate a hash value
    public var hashValue: Int
    {
            return self.name.hashValue
    }
    
    //MARK:- Generic implementations of Exchange protocol functions
    
    // a genric implementation that loops through each instrument calling getTicker in parallel
    // once all the tickers have been received they are passed back through the callback
    // if any getTicker calls return an error the error is passed bcack through the callback.
    // Only the first error is returned if there are multiple errors. That is, the callback is only called once
    func getTickers (instruments: [Instrument], completionHandler: (tickers: [Ticker]?, error: NSError?) -> () )
    {
        func iterator(
            instrument: Instrument,
            iteratorCompletionHandler: (ticker: Ticker?, error: NSError?) -> ()
            ) -> ()
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
        func iterator(
            instrument: Instrument,
            iteratorCompletionHandler: (orderBook: OrderBook?, error: NSError?) -> ()
            ) -> ()
        {
            self.delegate.getOrderBook(instrument) {
                (orderBook, error) in
                
                iteratorCompletionHandler(orderBook: orderBook, error: error)
            }
        }
        
        Async.each(instruments, iterator: iterator, completionHandler: completionHandler)
    }
    
    //MARK:- Helper functions not in the Exchange protocol
    
    // set api key and secret from the Keychain
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
    
    func summedBalances(convertedTo: Asset) -> (Balance?, NSError?)
    {
        var totalBalance = Balance(asset: convertedTo)
        
        // for each account on the exchange
        for account in self.accounts
        {
            // for each balance in the account
            for balance in account.balances
            {
                // get the rate to convert the balance amounts to the desired asset
                if let exchangeRate = AssetExchanger.sharedAssetExchanger.getRate(balance.asset, toAsset: convertedTo)
                {
                    // increment the total and aavailable amounts
                    totalBalance.total += balance.total * exchangeRate
                    totalBalance.available += balance.available * exchangeRate
                }
                else
                {
                    let error = ABTradingError.CreateWithReason(
                        "Could not sum balances of the \(self.name) exchange",
                        "Could not find an exchange rate to convert \(balance.asset.code) to \(convertedTo.code)").error
                    
                    return (nil, error)
                }
            }
        }
        
        return (totalBalance, nil)
    }
    
    //MARK:- Empty Exchange protocol functions that should be implemented in the subclass
    
    
    
    func addOrder(newOrder: Order, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(exchangeOrder: nil, error: error)
    }
    
    func cancelOrder(oldOrder: Order, completionHandler: (error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(error: error)
    }
    
    func getOrder(exchangeId: String, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(exchangeOrder: nil, error: error)
    }
    
    func getOpenOrders(instrument: Instrument, completionHandler: (exchangeOrder: Order?, error: NSError?) -> () )
    {
        let error = ABTradingError.MethodNotImplemented.error
        log.error(error.description)
        
        completionHandler(exchangeOrder: nil, error: error)
    }
}