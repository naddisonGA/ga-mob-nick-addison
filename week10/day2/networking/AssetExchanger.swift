//
//  AssetConverter.swift
//  currencyConverter
//
//  Created by Nicholas Addison on 3/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Dollar
import Cent
import TaskQueue

public class AssetExchanger
{
    static let sharedAssetExchanger = AssetExchanger()
    
    var exchangeTickers = [Ticker]()
    var crossRateTickers = [Ticker]()
    
    var instrumentToExchangeMap = [Instrument: Exchange]()
    var crossRatesMap = [Instrument: [Instrument]]()
    
    //MARK:- get rate functions
    
    
    // rate to sell fromAsset and buy toAsset
    // sell AUD and buy USD will use the AUDUSD bid rate as the AUD is being sold
    // buy AUD and sell USD will use the 1 / AUDUSD bid rate
    public func getRate(fromAsset: Asset, toAsset: Asset) -> Double?
    {
        log.debug("About to try and get rate to convert \(fromAsset.code) to \(toAsset.code)")
        
        if fromAsset == toAsset
        {
            return 1
        }
        else if let exchangeRate = getRateFromExchangeTickers(fromAsset, toAsset: toAsset)
        {
            return exchangeRate
        }
        
        if let crossRate = getRateFromCrossRateTickers(fromAsset, toAsset: toAsset)
        {
            return crossRate
        }
        
        log.error("Counld not find rate to exchange \(fromAsset.code) for \(toAsset.code) in \(self.exchangeTickers.count) exchange tickers or \(self.crossRateTickers.count) cross rate tickers")
        
        return nil
    }
    
    func getRateFromExchangeTickers(fromAsset: Asset, toAsset: Asset) -> Double?
    {
        return getRateFromTickers(exchangeTickers, fromAsset: fromAsset, toAsset: toAsset)
    }
    
    func getRateFromCrossRateTickers(fromAsset: Asset, toAsset: Asset) -> Double?
    {
        return getRateFromTickers(crossRateTickers, fromAsset: fromAsset, toAsset: toAsset)
    }
    
    //
    func getRateFromTickers(tickers: [Ticker], fromAsset: Asset, toAsset: Asset) -> Double?
    {
        log.debug("About to try and get rate to convert \(fromAsset.code) to \(toAsset.code) in \(tickers.count) tickers")
        
        if let ticker = $.find(tickers, callback: {
            $0.instrument.baseAsset == fromAsset &&
                $0.instrument.quoteAsset == toAsset })
        {
            // selling base asset so need bid rate. eg
            // exchange AUD for USD will use AUDUSD bid rate as we are selling AUD or USD
            return ticker.bid
        }
        
        if let invertedTicker = $.find(tickers, callback: {
            $0.instrument.baseAsset == toAsset &&
                $0.instrument.quoteAsset == fromAsset })
        {
            // need to invert the rate as we want to go from the quote to base asset
            return 1 / invertedTicker.ask
        }
        
        return nil
    }
    
    //MARK:- unique insturments and exchanges
    
    // get all instruments mapped to a specific exchange
    public func mappedInstruments(forExchange: Exchange) -> [Instrument]
    {
        var instruments = [Instrument]()
        
        for (instrument, exchange) in instrumentToExchangeMap
        {
            // if exchange's match and
            // instrument is NOT in the list of instruments to be returned
            if exchange.name == forExchange.name &&
                !$.contains(instruments, value: instrument)
            {
                instruments << instrument
            }
        }
        
        return instruments
    }
    
    // get a unique list of mapped exchanges
    public func mappedExchanges() -> [Exchange]
    {
        //let allExchanegs: [Exchange] = $.values(instrumentToExchangeMap)
        //let uniqueExchanges = $.uniq(allExchanegs) { $0.name }
        
        var mappedExchanges = [Exchange]()
        
        for (instrument, exchange) in instrumentToExchangeMap
        {
            var isMappedExchange = false
            
            for mappedExchange in mappedExchanges
            {
                if mappedExchange == exchange
                {
                    isMappedExchange = true
                    break
                }
            }
            
            if !isMappedExchange
            {
                mappedExchanges << exchange
            }
        }
        
        return mappedExchanges
    }
    
    //MARK:- update ticker functions
    
    public func updateTickers(completionHandler: (error: NSError?) -> () )
    {
        log.debug("about to get latest prices from the exchanges")
        
        let uniqueExchanges: [Exchange] = mappedExchanges()
        
        // get tickers from exchange for given instruments
        func iteratorFunc(exchange: Exchange, iteratorCallback: (tickers: [Ticker]?, error: NSError?) -> () )
        {
            exchange.getTickers(mappedInstruments(exchange))
            {
                (tickers: [Ticker]?, error) in
                
                iteratorCallback(tickers: tickers, error: nil)
            }
        }

        // get tickers for each exchange
        Async.each(uniqueExchanges, iterator: iteratorFunc)
        {
            (tickers: [Ticker]?, error) in
            
            if let tickers = tickers
            {
                self.exchangeTickers = tickers
            }
            else
            {
                self.exchangeTickers = [Ticker]()
            }
            
            self.updateCrossRateTickers()
            
            completionHandler(error: error)
        }
    }
    
    func updateCrossRateTickers()
    {
        crossRateTickers = [Ticker]()
        
        for (crossRateInstrument, crossRateInstrumentChain) in crossRatesMap
        {
            var crossAskRate: Double = 1
            var crossBidRate: Double = 1
            
            for insturmentLeg in crossRateInstrumentChain
            {
                if let legBidRate = getRate(insturmentLeg.baseAsset, toAsset: insturmentLeg.quoteAsset)
                {
                    crossBidRate *= legBidRate
                }
                else
                {
                    break
                }

                if let legAskRate = getRate(insturmentLeg.quoteAsset, toAsset: insturmentLeg.baseAsset)
                {
                    crossAskRate *= 1 / legAskRate
                }
                else
                {
                    break
                }
            }
            
            let crossRateTicker = Ticker (
                // hard coding to oanda for now
                exchange: oanda,
                instrument: crossRateInstrument,
                ask: crossAskRate,
                bid: crossBidRate,
                lastPrice: nil,
                timestamp: NSDate() )
            
            log.debug("Cross rate ticker for \(crossRateInstrument.code(.UpperCase)) bid \(crossAskRate) ask \(crossBidRate)")
            
            crossRateTickers.append(crossRateTicker)
        }
    }
}