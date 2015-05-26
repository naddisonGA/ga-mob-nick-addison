//
//  AssetExchangerTests.swift
//  networking
//
//  Created by Nicholas Addison on 12/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import XCTest

class AssetExchangerTests: XCTestCase {

    var assetExchanger = AssetExchanger.sharedAssetExchanger
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        assetExchanger = AssetExchanger.sharedAssetExchanger
        
        AssetExchanger.sharedAssetExchanger.instrumentToExchangeMap = defaultInstrumentToExchangeMap
        AssetExchanger.sharedAssetExchanger.crossRatesMap = defaultCrossRatesMap
        
        // set test tickets
        assetExchanger.exchangeTickers = [Ticker]()
        
        assetExchanger.exchangeTickers.append(Ticker(exchange: oanda, instrument: AUDUSD, ask: 0.78, bid: 0.76, lastPrice: 0.777, timestamp: NSDate()))
        assetExchanger.exchangeTickers.append(Ticker(exchange: oanda, instrument: USDCNY, ask: 6.3333, bid: 6.1234, lastPrice: 6, timestamp: NSDate()))
        assetExchanger.exchangeTickers.append(Ticker(exchange: bitfinex, instrument: BTCUSD, ask: 251, bid: 248, lastPrice: 250, timestamp: NSDate()))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMappedExchanges()
    {
        let mappedExchanges = assetExchanger.mappedExchanges()
        
        XCTAssertEqual(mappedExchanges.count, 2)
    }
    
    func testMappedInstrumentsForExchange()
    {
        let instruments = assetExchanger.mappedInstruments(oanda)
        
        XCTAssertEqual(instruments.count, 2)
    }
    
    //MARK:- Get rate tests
    
    func testGetRateWithNoTickers()
    {
        assetExchanger.exchangeTickers = [Ticker]()
        
        let audusd = assetExchanger.getRate(AUD, toAsset: USD)
        
        XCTAssertNil(audusd)
    }
    
    func testGetRateFromExchangeTicker()
    {
        let rate = assetExchanger.getRate(AUD, toAsset: USD)
        
        XCTAssertNotNil(rate)

        if let rate = rate
        {
            // Selling AUD and
            // Buying USD so use AUDUSD bid rate
            // ie selling 1 AUD for 0.76 USD
            XCTAssertEqual(rate, 0.76)
        }
    }
    
    func testGetRateFromInvertedExchangeTicker()
    {
        let rate = assetExchanger.getRate(USD, toAsset: AUD)
        
        XCTAssertNotNil(rate)
        
        if let rate = rate
        {
            // Buying AUD
            // Selling USD so use 1 / AUDUSD ask rate
            // ie selling 1 USD for 1.28 AUD
            XCTAssertEqual(rate, 1 / 0.78)
        }
    }
    
    func testUpdateCrossRateTickersAUDCNY()
    {
        assetExchanger.crossRatesMap = [AUDCNY: [AUDUSD, USDCNY]]
            
        assetExchanger.updateCrossRateTickers()
        
        XCTAssertEqual(assetExchanger.crossRateTickers.count, 1)
        
        if let ticker = assetExchanger.crossRateTickers.first
        {
            // AUDCNY ask = is rate for selling CNY for 1 AUD
            // AUDUSD ask * USDCNY ask = 0.78 * 6.3333
            XCTAssertEqual(ticker.ask, 0.78 * 6.3333)
            
            // AUDCNY bid is rate for selling 1 AUD for CNY
            // AUDUSD bid * USDCNY bid = 0.76 * 6.1234
            XCTAssertEqual(ticker.bid, 0.76 * 6.1234)
        }
    }
    
    func testGetRatesFromCrossRateTicker()
    {
        assetExchanger.crossRateTickers = [Ticker(exchange: oanda, instrument: AUDCNY, ask: 5.12, bid: 4.9, lastPrice: 5.0123, timestamp: NSDate())]
        
        let rate = assetExchanger.getRate(AUD, toAsset: CNY)
        
        XCTAssertNotNil(rate)
        
        if let rate = rate
        {
            // bid
            XCTAssertEqual(rate, 4.9)
        }
    }

    
    func testGetRatesFromInvertedCrossRateTicker()
    {
        assetExchanger.crossRateTickers = [Ticker(exchange: oanda, instrument: AUDCNY, ask: 5.12, bid: 4.9, lastPrice: 5.0123, timestamp: NSDate())]
        
        let rate = assetExchanger.getRate(CNY, toAsset: AUD)
        
        XCTAssertNotNil(rate)
        
        if let rate = rate
        {
            // 1 / ask
            XCTAssertEqual(rate, 1 / 5.12)
        }
    }
    
    //MARK:- update tickers tests
    
    func testUpdateExchangeTickers()
    {
        let expectation = expectationWithDescription("testUpdateExchangeTickers")
        
        assetExchanger.updateTickers {
            (error) in
            
            XCTAssertNil(error)
            
            log.debug("About to get rate to convert \(AUD.code) to \(USD.code)")
            
            let audusd = self.assetExchanger.getRate(AUD, toAsset: USD)
            
            XCTAssertNotNil(audusd)
            
            if let audusd = audusd
            {
                XCTAssertGreaterThan(audusd, 0.7)
                XCTAssertLessThan(audusd, 0.9)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in }
    }
    
    func testReserveExchangeTickers()
    {
        let expectation = expectationWithDescription("testReserveExchangeTickers")
        
        assetExchanger.updateTickers {
            (error) in
            
            XCTAssertNil(error)
            
            let usdaud = self.assetExchanger.getRate(USD, toAsset: AUD)
            
            XCTAssertNotNil(usdaud)
            
            if let usdaud = usdaud
            {
                XCTAssertGreaterThan(usdaud, 1.1)
                XCTAssertLessThan(usdaud, 1.3)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { (error) in }
    }
    
    func testCrossRateTickers()
    {
        let expectation = expectationWithDescription("testCrossRateTickers")
        
        assetExchanger.updateTickers {
            (error) in
            
            XCTAssertNil(error)
            
            let cnyaud = self.assetExchanger.getRate(CNY, toAsset: AUD)
            
            XCTAssertNotNil(cnyaud)
            
            if let cnyaud = cnyaud
            {
                XCTAssertGreaterThan(cnyaud, 0.15)
                XCTAssertLessThan(cnyaud, 0.25)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { (error) in }
    }
    
    func testReverseCrossRateTickers()
    {
        let expectation = expectationWithDescription("testReverseCrossRateTickers")
        
        assetExchanger.updateTickers {
            (error) in
            
            XCTAssertNil(error)
            
            let rate = self.assetExchanger.getRate(AUD, toAsset: CNY)
            
            XCTAssertNotNil(rate)
            
            if let rate = rate
            {
                XCTAssertGreaterThan(rate, 4.5)
                XCTAssertLessThan(rate, 5.5)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { (error) in }
    }
}
