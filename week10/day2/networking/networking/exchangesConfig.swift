//
//  exchangesConfig.swift
//  networking
//
//  Created by Nicholas Addison on 13/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

let defaultExchangeManagerExchanges: [Exchange] = [independentReserve, btcMarkets, bitfinex, btcChina, oanda]

// instance of BTC Markets
let independentReserve = IndependentReserve (
    name: "Independent Reserve",
    instruments: [BTCAUD, BTCUSD, BTCNZD],
    commissionRates: ExchangeCommissionRates(rates: [USD: 0, AUD: 0, NZD: 0, BTC: 0]),
    feeChargedIn: .QuoteAsset,
    accounts: [Account(username: "nick@addisonbrown.com.au", assets: [USD, AUD, NZD, BTC])] )

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

// instance of Oanda
let oanda = Oanda(
    name: "OandA",
    //FIXME: - need to handle CFD fees all in USD
    feeChargedIn: .QuoteAsset,
    commissionRates: ExchangeCommissionRates(rates: [AUD: 0.002, USD: 0.002, BTC: 0.002]),
    environment: .Practice )

// instance of BTCChina
let btcChina = BTCChina(
    name: "BTCChina",
    instruments: [BTCCNY, LTCCNY, LTCBTC],
    commissionRates: ExchangeCommissionRates(rates: [CNY: 0, BTC: 0, LTC: 0]),
    feeChargedIn: .BuyAsset,
    accounts: [Account(username: "nick@addisonbrown.com.au", assets: [CNY, BTC, LTC])] )