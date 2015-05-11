//
//  HMACEncodingTests.swift
//  networking
//
//  Created by Nicholas Addison on 5/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

import UIKit
import XCTest

class BinaryEncodingTests: XCTestCase
{
    func testHexStringToData()
    {
        // hexadecimal encoding of the following characters
        // ABCXYZ012789!@#$%^&*()_+<>?:"{}|
        let testString = "41424358595a30313237383921402324255e262a28295f2b3c3e3f3a227b7d7c"
        
        let expectedData = NSString(string: "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|").dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = BinaryEncoding.Hex.decode(fromEncodedString: testString)
        {
            XCTAssert(data.isEqualToData(expectedData!), "Encoded data did not match the expected data")
        }
        else
        {
            XCTAssert(false, "Could not encode hex string: " + testString)
        }
    }
    
    func testBase64StringToData()
    {
        // base64 encoding of the following characters
        // ABCXYZ012789!@#$%^&*()_+<>?:"{}|
        let testString = "QUJDWFlaMDEyNzg5IUAjJCVeJiooKV8rPD4/OiJ7fXw="
        
        let expectedData = NSString(string: "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|").dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = BinaryEncoding.Base64.decode(fromEncodedString: testString)
        {
            XCTAssert(data.isEqualToData(expectedData!), "")
        }
        else
        {
            XCTAssert(false, "Could not encode base64 string: " + testString)
        }
    }
    
    func testUTF8StringToData()
    {
        // ABCXYZ012789!@#$%^&*()_+<>?:"{}|
        let testString = "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|"
        
        let expectedData = NSString(string: "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|").dataUsingEncoding(NSUTF8StringEncoding)
        
        if let data = BinaryEncoding.UTF8.decode(fromEncodedString: testString)
        {
            XCTAssert(data.isEqualToData(expectedData!), "")
        }
        else
        {
            XCTAssert(false, "Could not encode UTF8 string: " + testString)
        }
    }

    func testFailedHexDecoding()
    {
        // incorrect hexadecimal
        let testString = "414"
        
        let data = BinaryEncoding.Hex.decode(fromEncodedString: testString)
        
        XCTAssertNil(data, "Should not be able to decode incorrect hex string: " + testString)
    }
    
    func testFailedBase64Decoding()
    {
        // incorrect base64 encoded string
        let testString = "QUJDW"
        
        let data = BinaryEncoding.Base64.decode(fromEncodedString: testString)
        
        XCTAssertNil(data, "Should not be able to decode incorrect hex string: " + testString)
    }
    
    func testDataToBase64()
    {
        let testString = "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|"
        let testData = NSString(string: testString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let bufferPointer = UnsafeMutablePointer<UInt8>.alloc(testData!.length)
        
        testData!.getBytes(bufferPointer, length: testString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        let resultString = BinaryEncoding.Base64.encode(bufferPointer, length: testData!.length)
        
        let expectedString = "QUJDWFlaMDEyNzg5IUAjJCVeJiooKV8rPD4/OiJ7fXw="
        
        XCTAssertEqual(resultString!, expectedString)
    }
    
    func testDataToHex()
    {
        let testString = "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|"
        let testData = NSString(string: testString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let bufferPointer = UnsafeMutablePointer<UInt8>.alloc(testData!.length)
        
        testData!.getBytes(bufferPointer, length: testString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        let resultString = BinaryEncoding.Hex.encode(bufferPointer, length: testData!.length)
        
        let expectedString = "41424358595a30313237383921402324255e262a28295f2b3c3e3f3a227b7d7c"
        
        XCTAssertEqual(resultString!, expectedString)
    }
    
    func testDataToUTF8()
    {
        let testString = "ABCXYZ012789!@#$%^&*()_+<>?:\"{}|"
        let testData = NSString(string: testString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let bufferPointer = UnsafeMutablePointer<UInt8>.alloc(testData!.length)
        
        testData!.getBytes(bufferPointer, length: testString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        let resultString = BinaryEncoding.UTF8.encode(bufferPointer, length: testData!.length)
        
        XCTAssertEqual(resultString!, testString)
    }
}