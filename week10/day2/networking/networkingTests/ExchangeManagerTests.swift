//
//  ExchangeManagerTests.swift
//  networking
//
//  Created by Nicholas Addison on 8/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import XCTest

class ExchangeManagerTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ExchangeManager.sharedExchangeManager.exchanges = defaultExchangeManagerExchanges
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetAllBalances()
    {
        let expectation = expectationWithDescription("getBalances")
        
        ExchangeManager.sharedExchangeManager.getAllBalances {
            (error) in
            
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(30) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
}
