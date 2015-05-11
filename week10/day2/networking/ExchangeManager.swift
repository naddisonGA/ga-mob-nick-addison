//
//  ExchangeSingleton.swift
//  networking
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Dollar

/// Singleton of configured exchanges
class ExchangeManager
{
    private var _exchanges: [Exchange] = [btcMarkets, bitfinex, independentReserve]
    
    var exchanges: [Exchange] {
        return _exchanges
    }
    
    static let sharedExchangeManager = ExchangeManager()
    
    func findExchange(exchangeName: String) -> Exchange?
    {
        return $.find(_exchanges) { $0.name == exchangeName }
    }
    
    func addExchange(exchange: Exchange)
    {
        _exchanges.append(exchange)
    }
    
    // gets the balances from all the configured exchanges in parallel
    // the callback is called when either
    // 1. all exchange balances have been retreived
    // 2. there is an error from one of the exchanges
    // note that the callback will only be called once if there are multiple errors across the exchanges. The first error received will be returned and the supsequant errors will be ignored as the callback has already been called
    func getAllBalances(completionHandler: (error: NSError?) -> ())
    {
        func iteratorFunc(exchange: Exchange, iteratorCompletionHandler: (balances: [Balance]?, error: NSError?) -> () )
        {
            exchange.getBalances(iteratorCompletionHandler)
        }
        
        Async.each(
            _exchanges,
            iterator: iteratorFunc)
        {
            (balances: [Balance]?, error) in
            
            completionHandler(error: error)
        }
    }
}

//MARK:- exhcange instances

// instance of BTC Markets
let independentReserve = IndependentReserve (
    name: "Independent Reserve",
    instruments: [BTCAUD, BTCUSD],
    commissionRates: ExchangeCommissionRates(rates: [USD: 0.001, AUD: 0.001, BTC: 0.001]),
    feeChargedIn: .QuoteAsset,
    accounts: [Account(username: "nick@addisonbrown.com.au", assets: [USD, AUD, BTC])] )

// instance of BTC Markets
let btcMarkets = BTCMarkets(
    name: "BTC Markets",
    instruments: [BTCAUD, LTCAUD, LTCBTC],
    commissionRates: ExchangeCommissionRates(rates: [AUD: 0.001, BTC: 0.001, LTC: 0.001]),
    feeChargedIn: .QuoteAsset,
    accounts: [Account(username: "nick@addisonbrown.com.au", assets: [AUD, BTC, LTC])] )

// instance of BTC Markets
let bitfinex = Bitfinex(
    name: "Bitfinex",
    instruments: [BTCUSD, LTCUSD, LTCBTC],
    //FIXME: - need to handle maker and taker commissions
    commissionRates: ExchangeCommissionRates(rates: [AUD: 0.002, USD: 0.002, BTC: 0.002]),
    feeChargedIn: .BuyAsset,
    accounts: [Account(username: "nick@addisonbrown.com.au", assets: [USD, BTC, LTC, DRK])] )

// instance of BTC Markets
let oandaPractice = Oanda(
    name: "OandA",
    //FIXME: - need to handle CFD fees all in USD
    feeChargedIn: .QuoteAsset,
    commissionRates: ExchangeCommissionRates(rates: [AUD: 0.002, USD: 0.002, BTC: 0.002]),
    environment: .Practice )