//
//  AsyncTests.swift
//  networking
//
//  Created by Nicholas Addison on 15/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import XCTest

class Timeout
{
    var waitTime: Int64
    
    init(waitTime: Int64)
    {
        self.waitTime = waitTime
    }
    
    func asyncFunc(callback: (Int64?, NSError?) -> ())
    {
        var delta: Int64 = waitTime * Int64(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        
        println("about to wait \(waitTime) seconds")
        
        dispatch_after(time, dispatch_get_main_queue() )
            {
                println("finished waiting \(self.waitTime) seconds. Calling callback with Int result")
                
                callback(self.waitTime, nil)
        }
    }
    
    func asyncFunc(callback: (NSError?) -> () )
    {
        self.asyncFunc {
            (waitTIme: Int64?, error) in
            
            // don't return any reult in the callback - just return an optional NSError
            callback(error)
        }
    }
    
    func asyncFunc(callback: (String?, NSError?) -> ())
    {
        self.asyncFunc {
            (waitTime: Int64?, error) in
            
            // convert the result to  in the callback to a String
            callback("\(waitTime)", error)
        }
    }
}

class AsyncTests: XCTestCase
{
    let wait1 = Timeout(waitTime: 1)
    let wait2 = Timeout(waitTime: 2)
    let wait3 = Timeout(waitTime: 3)
    
    var waitArray: [Timeout] = []
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.waitArray = [wait3, wait1, wait2]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK:- each
    
    func testAsyncEachNoResult()
    {
        let expectation = expectationWithDescription("testAsyncEachNoResult")
        
        var whenIteratorCalled = [NSTimeInterval]()
        
        func iterator(timeout: Timeout, callback: (NSError?) -> () )
        {
            timeout.asyncFunc {
                (error: NSError?) in
                
                whenIteratorCalled.append( NSDate().timeIntervalSince1970 )
                
                callback(error)
            }
        }
        
        Async.each(waitArray, iterator: iterator)
        {
            error in
            
            println("Finaished iterating over the array")
            
            XCTAssertEqual(whenIteratorCalled.count, 3 )
            XCTAssertLessThan(whenIteratorCalled[0], whenIteratorCalled[1] )
            XCTAssertLessThan(whenIteratorCalled[1], whenIteratorCalled[2] )
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in }
    }
    
    func testAsyncEachInt64Result()
    {
        let expectation = expectationWithDescription("testAsyncEachInt64Result")
        
        var results = [Int64?]()
        
        func iterator(timeout: Timeout, callback: (Int64?, NSError?) -> () )
        {
            timeout.asyncFunc {
                (waitTime: Int64?, error) in
                
                results.append(waitTime)
                
                callback(waitTime, error)
            }
        }
        
        Async.each(waitArray, iterator: iterator)
        {
            resultsArray, error in
            
            println("Finaished iterating over the array")
            
            XCTAssertEqual(results.count, 3)
            
            XCTAssertEqual(results[0]!, 1)
            XCTAssertEqual(results[1]!, 2)
            XCTAssertEqual(results[2]!, 3)
            
            XCTAssertEqual(resultsArray![0], 1)
            XCTAssertEqual(resultsArray![1], 2)
            XCTAssertEqual(resultsArray![2], 3)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in }
    }
    
    //MARK:- eachSeries
    
    func testAsyncEachSeriesNoResult()
    {
        let expectation = expectationWithDescription("testAsyncEachSeriesNoResult")
        
        var whenIteratorCalled = [NSTimeInterval]()
        
        func iterator(timeout: Timeout, callback: (NSError?) -> () )
        {
            timeout.asyncFunc {
                (error: NSError?) in
                
                whenIteratorCalled.append( NSDate().timeIntervalSince1970 )
                
                callback(error)
            }
        }
        
        Async.eachSeries(waitArray, iterator: iterator)
            {
                error in
                
                println("Finaished iterating over the array")
                
                XCTAssertEqual(whenIteratorCalled.count, 3 )
                
                XCTAssertLessThan(whenIteratorCalled[0], whenIteratorCalled[1] )
                XCTAssertLessThan(whenIteratorCalled[1], whenIteratorCalled[2] )
                
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in }
    }
    
    func testAsyncEachSeriesInt64Result()
    {
        let expectation = expectationWithDescription("testAsyncEachSeriesInt64Result")
        
        var whenIteratorCalled = [NSTimeInterval]()
        
        func iterator(timeout: Timeout, callback: (result: Int64?, error: NSError?) -> () )
        {
            timeout.asyncFunc {
                (result: Int64?, error: NSError?) in
                
                whenIteratorCalled.append( NSDate().timeIntervalSince1970 )
                
                callback(result: result, error: error)
            }
        }
        
        Async.eachSeries(waitArray, iterator: iterator)
            {
                (results: [Int64]?, error: NSError?) in
                
                println("Finaished iterating over the array")
                
                XCTAssertEqual(whenIteratorCalled.count, 3 )
                
                XCTAssertEqual(results![0], 3)
                XCTAssertEqual(results![1], 1)
                XCTAssertEqual(results![2], 2)
                
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) in }
    }
    
//    func testAsyncSeries()
//    {
//        let expectation = expectationWithDescription("testAsyncSeries")
//        
//        var taskWasCalled = [NSTimeInterval]()
//        
//        var tasks = Array<(callback: (result: Any?, error: NSError?) ->() ) -> ()>()
//        //var tasks = [Any]()
//        
////        func first(callback: (result: Any?, error: NSError?) ->() ) {
////            callback("result", nil)
////        }
//        
//        Async.series(tasks)
//            {
//                (results: [Any]?, error: NSError?) in
//                
//                println("Finaished iterating over the array")
//                
//                if let results = results
//                {
//                    //resultsInt64
//                }
//                
//                XCTAssertEqual(whenIteratorCalled.count, 3 )
//                
//                XCTAssertEqual(results![0], 3)
//                XCTAssertEqual(results![1], 1)
//                XCTAssertEqual(results![2], 2)
//                
//                expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(10) { (error) in }
//    }
}
