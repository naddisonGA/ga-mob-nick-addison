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

class AssetExchanger
{
    static let sharedAssetExchanger = AssetExchanger()
    
    private var _tickers = [Ticker]()
    
    let instrumentToExchangeMap: [Instrument: Exchange] = [
        AUDUSD: oandaPractice,
        USDCNY: oandaPractice,
        BTCUSD: bitfinex,
        LTCUSD: bitfinex,
        DRKUSD: bitfinex
    ]
    
    let crossRatesMap: [Instrument: [Instrument]] = [
        CNYAUD: [CNYUSD, USDAUD],
        DRKAUD: [DRKAUD, AUDUSD],
        LTCAUD: [LTCUSD, USDAUD]
    ]
    
    func getRate(fromAsset: Asset, toAsset: Asset) -> Double?
    {
        if let ticker = $.find(self._tickers, callback: {
            $0.instrument.baseAsset == fromAsset &&
            $0.instrument.quoteAsset == toAsset })
        {
            return ticker.ask
        }
        
        if let reverseTicker = $.find(self._tickers, callback: {
            $0.instrument.baseAsset == toAsset &&
                $0.instrument.quoteAsset == fromAsset })
        {
            return reverseTicker.bid
        }
        
        return nil
    }
    
    func mappedInstruments(forExchange: Exchange) -> [Instrument]
    {
        var instruments = [Instrument]()
        
        for (instrument, exchange) in instrumentToExchangeMap
        {
            if exchange.name == forExchange.name &&
                $.contains(instruments, value: instrument)
            {
                instruments << instrument
            }
        }
        
        return instruments
    }
    
    func mappedExchanges() -> [Exchange]
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
    
    func updateTickers(completionHandler: (error: NSError?) -> () )
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
                self._tickers = tickers
            }
            else
            {
                self._tickers = [Ticker]()
            }
            
            completionHandler(error: error)
        }
    }
}