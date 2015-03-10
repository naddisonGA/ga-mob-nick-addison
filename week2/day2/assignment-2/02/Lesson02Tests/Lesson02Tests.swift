//
//  Lesson02Tests.swift
//  Lesson02Tests
//
//  Created by Rudd Taylor on 9/28/14.
//  Copyright (c) 2014 General Assembly. All rights reserved.
//

import UIKit
import XCTest

import Lesson02

class Lesson02Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // TODO get the following to work
        //let fibAdder = FibAdder()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    let fibAdder = FibAdder()
    
    func testFibAtIndex1() {
        XCTAssert(fibAdder.fibonacciNumberAtIndex(1) == 0, "Pass")
    }
    
    func testFibAtIndex2() {
        XCTAssert(fibAdder.fibonacciNumberAtIndex(2) == 1, "Pass")
    }
    
    func testFibAtIndex3() {
        XCTAssert(fibAdder.fibonacciNumberAtIndex(3) == 1, "Pass")
    }
    
    func testFibAtIndex4() {
        XCTAssert(fibAdder.fibonacciNumberAtIndex(4) == 2, "Pass")
    }
    
    func testFibAtIndex5() {
        XCTAssert(fibAdder.fibonacciNumberAtIndex(5) == 3, "Pass")
    }
    
    func testFibAtIndex6() {
        XCTAssert(fibAdder.fibonacciNumberAtIndex(6) == 5, "Pass")
    }
}
