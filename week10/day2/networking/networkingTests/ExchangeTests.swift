//
//  networkingTests.swift
//  networkingTests
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import XCTest
import XCGLogger

let log = XCGLogger.defaultInstance()

class ExchangeTests: XCTestCase
{
    //////// set exchange and instrument to test here:
//    let testExchange: Exchange = btcMarkets
//    let testInstrument = BTCAUD
    
//    let testExchange: Exchange = bitfinex
//    let testInstrument = BTCUSD
//    let testInstruments = [BTCUSD, LTCUSD]
//    let testCurrency = USD
    
    let testExchange: Exchange = independentReserve
    let testInstrument = BTCAUD
    let testInstruments = [BTCAUD, LTCAUD]
    let testCurrency = AUD

    let minBid = 200.0
    let maxAsk = 500.0

//    let testExchange: Exchange = btcChina
//    let testInstrument = BTCCNY
//    let testInstruments = [BTCCNY, LTCBTC]
//    let minBid = 1300.0
//    let maxAsk = 1600.0
    
//    let testExchange: Exchange = oanda
//    let testInstrument = AUDUSD
//    let testInstruments = [AUDUSD, USDCNY]
//    let minBid = 0.7
//    let maxAsk = 0.9
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ExchangeManager.sharedExchangeManager.exchanges = defaultExchangeManagerExchanges
        CurrencyManager.sharedCurrencyManager.currencies = defaultCurrencyManagerCurrencies
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetTicker()
    {
        let expectation = expectationWithDescription("getTicker")
        
        testExchange.getTicker(testInstrument) { (ticker, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(ticker)
            
            if let ticker = ticker
            {
                XCTAssert(ticker.exchange == self.testExchange)
                XCTAssert(ticker.instrument == self.testInstrument)
                
                XCTAssertGreaterThan(ticker.bid, self.minBid)
                XCTAssertLessThan(ticker.ask, self.maxAsk)
                
                if let lastPrice = ticker.lastPrice
                {
                    XCTAssertGreaterThan(lastPrice, self.minBid)
                    XCTAssertLessThan(lastPrice, self.maxAsk)
                }
                
                XCTAssertNotNil(ticker.timestamp)
            }
            
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
    
    func testGetTickers()
    {
        let expectation = expectationWithDescription("testGetTickers")
        
        testExchange.getTickers(testInstruments)
        {
            tickers, error in
            
            XCTAssertNil(error)
            XCTAssertNotNil(tickers)
            
            if let tickers = tickers
            {
                XCTAssert(tickers[0].exchange == self.testExchange)
                XCTAssert(tickers[0].instrument == self.testInstruments[0])
                
                XCTAssert(tickers[1].exchange == self.testExchange)
                XCTAssert(tickers[1].instrument == self.testInstruments[1])
                XCTAssertEqual(tickers[1].instrument.code(.UpperCase), self.testInstruments[1].code(.UpperCase) )
                
                XCTAssertGreaterThan(tickers[0].bid, self.minBid)
                XCTAssertLessThan(tickers[0].ask, self.maxAsk)
                
                if let lastPrice = tickers[0].lastPrice
                {
                    XCTAssertGreaterThan(lastPrice, self.minBid)
                    XCTAssertLessThan(lastPrice, self.maxAsk)
                }
                
                XCTAssertNotNil(tickers[0].timestamp)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
    
    func testGetOrderBook()
    {
        let expectation = expectationWithDescription("getOrderBook")
        
        testExchange.getOrderBook(testInstrument)
        {
            orderBook, error in
            
            XCTAssertNil(error)
            XCTAssertNotNil(orderBook)
            
            if error != nil {return}
            
            XCTAssertGreaterThan(orderBook!.asks.count, 0)
            XCTAssertGreaterThan(orderBook!.bids.count, 0)
            
            if let firstAsk = orderBook!.asks.first
            {
                XCTAssertGreaterThan(firstAsk.price, 200)
            }
            
            if let firstBid = orderBook!.bids.first
            {
                XCTAssertGreaterThan(firstBid.price, 200)
            }
            
            XCTAssertNotNil(orderBook!.timestamp)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
    
    func testGetBalances()
    {
        let expectation = expectationWithDescription("getBalances")
        
        testExchange.getBalances() { (balances, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(balances)
            
            if let balances = balances
            {
                XCTAssertGreaterThan(balances.count, 0)
                
                var foundTestCurrency = false
                
                for balance in balances
                {
                    if balance.asset == self.testCurrency
                    {
                        XCTAssertGreaterThan(balance.total, 0)
                        XCTAssertGreaterThan(balance.available, 0)
                        
                        foundTestCurrency = true
                    }
                }
                
                if !foundTestCurrency
                {
                    XCTAssert(false, "Could not get the balance of the test currency \(self.testCurrency.code)")
                }
                
                XCTAssertGreaterThan(self.testExchange.accounts.first!.balances.count, 0)
                XCTAssertEqual(self.testExchange.accounts.first!.balances.count, balances.count)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
}
