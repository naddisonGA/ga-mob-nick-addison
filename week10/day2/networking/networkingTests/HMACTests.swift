//
//  HMACTests.swift
//  networking
//
//  Created by Nicholas Addison on 5/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

import XCTest

class HMACTests: XCTestCase
{
    func testDefaultHMAC512()
    {
        let hmac = HMAC(algorithm: .SHA512)
        
        // test message is a JSON string:
        // {"currency":"AUD","instrument":"BTC","price":13000000000,"volume":10000000,"orderSide":"Bid","ordertype":"Limit","clientRequestId":"abc-cdf-1000"}
        let testMessage = "{\"currency\":\"AUD\",\"instrument\":\"BTC\",\"price\":13000000000,\"volume\":10000000,\"orderSide\":\"Bid\",\"ordertype\":\"Limit\",\"clientRequestId\":\"abc-cdf-1000\"}"
        
        let digest: String? = hmac.createDigest(testMessage, secretStr: "!@#$%^&*()ABCXYZ012789")
        
        let expected = "p69r3FSp4wSaDV/NpEglwXJtNlvQ46BSNC6nCLFWKcb+3HILttTDE98EqprbBg0hWwBdsQ8Q0emTc9rtrjwqXg=="
        
        XCTAssertNotNil(digest)
        XCTAssertEqual(digest!, expected)
    }
    
    func testBase64SecretDigestHMAC512()
    {
        let hmac = HMAC(algorithm: .SHA512, secretDecoding: .Base64,
            messageEncoding: .UTF8, digestEncoding: .Base64)
        
        // test message is a JSON string:
        // {"currency":"AUD","instrument":"BTC","price":13000000000,"volume":10000000,"orderSide":"Bid","ordertype":"Limit","clientRequestId":"abc-cdf-1000"}
        let testMessage = "{\"currency\":\"AUD\",\"instrument\":\"BTC\",\"price\":13000000000,\"volume\":10000000,\"orderSide\":\"Bid\",\"ordertype\":\"Limit\",\"clientRequestId\":\"abc-cdf-1000\"}"
        
        let testSecret = "MDEyMzQ1Njc4OQ==" // base64 of 0123456789
        let expectedDigest = "xUllXKgWN2oYgvIbApp7ncdnZBZhpks2uLjMGkps0WHlIhVwcv9R2tHvzNoFk0fUeRqJzI4NTOmB2mCiir6zEA=="
        
        let digest: String? = hmac.createDigest(testMessage, secretStr: testSecret)
        
        XCTAssertNotNil(digest)
        XCTAssertEqual(digest!, expectedDigest)
    }
    
    func testBase64DigestHMAC256()
    {
        let hmac = HMAC(algorithm: .SHA256, digestEncoding: .Base64)
        
        let testMessage = "Message"
        let testSecret = "secret"
        let expectedDigest = "qnR8UCqJggD55PohusaBNviGoOJ67HC6Btry4qXLVZc="
        
        let digest: String? = hmac.createDigest(testMessage, secretStr: testSecret)
        
        XCTAssertNotNil(digest)
        XCTAssertEqual(digest!, expectedDigest)
        XCTAssertEqual(digest!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), expectedDigest.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) )
        
    }
}