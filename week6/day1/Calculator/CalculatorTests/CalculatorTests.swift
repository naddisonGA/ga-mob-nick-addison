//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Nicholas Addison on 31/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import XCTest

import Calculator

class CalculatorTests: XCTestCase {
    
    var calculator = Calculator()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        calculator = Calculator()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitCalculator()
    {
        let display = calculator.display
        XCTAssertEqual(display, "0")
    }
    
    //MARK: - addDigitToDisplay tests
    
    func testAddOneToDisplay()
    {
        let display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
    }
    
    func testAddDecimalToDisplay()
    {
        let display = calculator.addDigitToDisplay(".")
        XCTAssertEqual(display, "0.")
    }
    
    func testAddOneThenDecimalToDisplay()
    {
        var display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay(".")
        XCTAssertEqual(display, "1.")
    }
    
    //MARK: - addition tests
    
    // 1 + 2 = 3
    func testOnePlusTwoEquals()
    {
        var display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "2")
        
        display = calculator.equals()
        XCTAssertEqual(display, "3")
    }
    
    // 12 + 50 = 62
    func testTwelvePlusFiftyEquals()
    {
        var display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "12")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "12")
        
        display = calculator.addDigitToDisplay("5")
        XCTAssertEqual(display, "5")
        
        display = calculator.addDigitToDisplay("0")
        XCTAssertEqual(display, "50")
        
        display = calculator.equals()
        XCTAssertEqual(display, "62")
    }
    
    // 0.1 + 0.2 = 0.3
    func testOneThenthPlusTwoTenthsEquals()
    {
        var display = calculator.addDigitToDisplay(".")
        XCTAssertEqual(display, "0.")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "0.1")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "0.1")
        
        display = calculator.addDigitToDisplay(".")
        XCTAssertEqual(display, "0.")
        
        display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "0.2")
        
        display = calculator.equals()
        XCTAssertEqual(display, "0.3")
    }
    
    // 1 + 2 + 12 = 15
    func testOnePlusTwoPlusTwelveEquals()
    {
        var display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "2")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "3")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "12")
        
        display = calculator.equals()
        XCTAssertEqual(display, "15")
    }
    
    // 2 + + + =
    func testTwoPlusPlusEquals()
    {
        var display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "2")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "2")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "4")
        
        display = calculator.setOperation(.Plus)
        XCTAssertEqual(display, "8")
        
        display = calculator.equals()
        XCTAssertEqual(display, "16")
    }
    
    //MARK: - substraction tests
    
    // 3 - 1 = 2
    func testThreeMinusOneEquals()
    {
        var display = calculator.addDigitToDisplay("3")
        XCTAssertEqual(display, "3")
        
        display = calculator.setOperation(.Minus)
        XCTAssertEqual(display, "3")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.equals()
        XCTAssertEqual(display, "2")
    }
    
    // 3 - 1 = = 2
    func testThreeMinusOneEqualsEquals()
    {
        var display = calculator.addDigitToDisplay("3")
        XCTAssertEqual(display, "3")
        
        display = calculator.setOperation(.Minus)
        XCTAssertEqual(display, "3")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.equals()
        XCTAssertEqual(display, "2")
        
        display = calculator.equals()
        XCTAssertEqual(display, "2")
    }
    
    // 33 - 11 = 22
    func testThirtyThreeMinusElevenEquals()
    {
        var display = calculator.addDigitToDisplay("3")
        XCTAssertEqual(display, "3")
        
        display = calculator.addDigitToDisplay("3")
        XCTAssertEqual(display, "33")
        
        display = calculator.setOperation(.Minus)
        XCTAssertEqual(display, "33")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "11")
        
        display = calculator.equals()
        XCTAssertEqual(display, "22")
    }
    
    // 33 - 11 - 50 = -28
    func testThirtyThreeMinusElevenMinusFiftyEquals()
    {
        var display = calculator.addDigitToDisplay("3")
        XCTAssertEqual(display, "3")
        
        display = calculator.addDigitToDisplay("3")
        XCTAssertEqual(display, "33")
        
        display = calculator.setOperation(.Minus)
        XCTAssertEqual(display, "33")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "1")
        
        display = calculator.addDigitToDisplay("1")
        XCTAssertEqual(display, "11")
        
        display = calculator.setOperation(.Minus)
        XCTAssertEqual(display, "22")
        
        display = calculator.addDigitToDisplay("5")
        XCTAssertEqual(display, "5")
        
        display = calculator.addDigitToDisplay("0")
        XCTAssertEqual(display, "50")

        display = calculator.equals()
        XCTAssertEqual(display, "-28")
    }
    
    
    //MARK: - division tests
    
    // 6 / 2 = 3
    func testSixDivTwoEquals()
    {
        var display = calculator.addDigitToDisplay("6")
        XCTAssertEqual(display, "6")
        
        display = calculator.setOperation(.Div)
        XCTAssertEqual(display, "6")
        
        display = calculator.addDigitToDisplay("2")
        XCTAssertEqual(display, "2")
        
        display = calculator.equals()
        XCTAssertEqual(display, "3")
    }
    
    // 6 / 0 = Error
    func testSixDivZeroEquals()
    {
        var display = calculator.addDigitToDisplay("6")
        XCTAssertEqual(display, "6")
        
        display = calculator.setOperation(.Div)
        XCTAssertEqual(display, "6")
        
        display = calculator.addDigitToDisplay("0")
        XCTAssertEqual(display, "0")
        
        display = calculator.equals()
        XCTAssertEqual(display, "Error")
    }
}
