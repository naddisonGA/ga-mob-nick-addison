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
    
    let testExchange: Exchange = independentReserve
    let testInstrument = BTCAUD
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
            
            XCTAssert(ticker!.exchange == self.testExchange)
            XCTAssert(ticker!.instrument == self.testInstrument)
            
            XCTAssertGreaterThan(ticker!.bid, 200)
            XCTAssertLessThan(ticker!.ask, 500)
            
            XCTAssertGreaterThan(ticker!.lastPrice!, 200)
            XCTAssertLessThan(ticker!.lastPrice!, 500)
            
            XCTAssertNotNil(ticker!.timestamp)
            
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
    
    func xtestGetOrderBook()
    {
        let expectation = expectationWithDescription("getOrderBook")
        
        testExchange.getOrderBook(testInstrument) { (orderBook, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(orderBook)
            
            if error != nil {return}
            
            XCTAssertGreaterThan(orderBook!.bids.first!.price, 200)
            XCTAssertLessThan(orderBook!.asks.first!.price, 500)
            
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
                
                XCTAssertGreaterThan(balances.first!.total, 0)
                XCTAssertGreaterThan(balances.first!.available, 0)
                XCTAssertNotNil(balances.first!.asset)
                
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
