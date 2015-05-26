//
//  keychainTest.swift
//  networking
//
//  Created by Nicholas Addison on 4/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

import UIKit
import XCTest

class KeychainTests: XCTestCase
{
    func xxxtestAddBitfinexApiKeysToKeychain()
    {
        let apiKey = ""
        let apiSecret = ""
        
        let apiKeySet: Bool = Keychain.set(bitfinex.keychainKeyForApiKey, value: apiKey)
        let apiSecretSet: Bool = Keychain.set(bitfinex.keychainKeyForApiSecret, value: apiSecret)
        
        XCTAssertTrue(apiKeySet, "set api key in Keychain")
        XCTAssertTrue(apiSecretSet, "set api secret in Keychain")
        
        let getApiKey = Keychain.get(bitfinex.keychainKeyForApiKey)
        let getApiSecret = Keychain.get(bitfinex.keychainKeyForApiSecret)
        
        XCTAssertEqual(getApiKey!, apiKey, "retrieved api key value from keychain matches raw string")
        XCTAssertEqual(getApiSecret!, apiSecret, "retrieved api secret value from keychain matches raw string")
    }
    
    func xxxtestAddIndependentReserveApiKeysToKeychain()
    {
        let apiKey = ""
        let apiSecret = ""
        
        let apiKeyWasSet: Bool = Keychain.set(independentReserve.keychainKeyForApiKey, value: apiKey)
        let apiSecretWasSet: Bool = Keychain.set(independentReserve.keychainKeyForApiSecret, value: apiSecret)
        
        XCTAssertTrue(apiKeyWasSet, "set api key in Keychain")
        XCTAssertTrue(apiSecretWasSet, "set api secret in Keychain")
        
        let getApiKey = Keychain.get(independentReserve.keychainKeyForApiKey)
        let getApiSecret = Keychain.get(independentReserve.keychainKeyForApiSecret)
        
        XCTAssertEqual(getApiKey!, apiKey, "retrieved api key value from keychain matches raw string")
        XCTAssertEqual(getApiSecret!, apiSecret, "retrieved api secret value from keychain matches raw string")
    }
    
    func xxxtestAddBTCMarketsApiKeysToKeychain()
    {
        let apiKey = ""
        let apiSecret = ""
        
        let apiKeyWasSet: Bool = Keychain.set(btcMarkets.keychainKeyForApiKey, value: apiKey)
        let apiSecretWasSet: Bool = Keychain.set(btcMarkets.keychainKeyForApiSecret, value: apiSecret)
        
        XCTAssertTrue(apiKeyWasSet, "set api key in Keychain")
        XCTAssertTrue(apiSecretWasSet, "set api secret in Keychain")
        
        let getApiKey = Keychain.get(btcMarkets.keychainKeyForApiKey)
        let getApiSecret = Keychain.get(btcMarkets.keychainKeyForApiSecret)
        
        XCTAssertEqual(getApiKey!, apiKey, "retrieved api key value from keychain matches raw string")
        XCTAssertEqual(getApiSecret!, apiSecret, "retrieved api secret value from keychain matches raw string")
    }
    
    func testAddOandaApiKeysToKeychain()
    {
        let apiKey = ""
        
        let apiKeyWasSet: Bool = Keychain.set(oanda.keychainKeyForApiKey, value: apiKey)
        
        XCTAssertTrue(apiKeyWasSet, "set api key in Keychain")
        
        let getApiKey = Keychain.get(oanda.keychainKeyForApiKey)
        
        XCTAssertEqual(getApiKey!, apiKey, "retrieved api key value from keychain matches raw string")
    }
    
    func xxxtestAddBTCChinaApiKeysToKeychain()
    {
        let apiKey = ""
        let apiSecret = ""
        
        let apiKeyWasSet: Bool = Keychain.set(btcChina.keychainKeyForApiKey, value: apiKey)
        let apiSecretWasSet: Bool = Keychain.set(btcChina.keychainKeyForApiSecret, value: apiSecret)
        
        XCTAssertTrue(apiKeyWasSet, "set api key in Keychain")
        XCTAssertTrue(apiSecretWasSet, "set api secret in Keychain")
        
        let getApiKey = Keychain.get(btcChina.keychainKeyForApiKey)
        let getApiSecret = Keychain.get(btcChina.keychainKeyForApiSecret)
        
        XCTAssertEqual(getApiKey!, apiKey, "retrieved api key value from keychain matches raw string")
        XCTAssertEqual(getApiSecret!, apiSecret, "retrieved api secret value from keychain matches raw string")
    }
    
    func testAddDummayKeysToKeychain()
    {
        let apiKey = "ABCDEFGH"
        let apiSecret = "1234567890"
        
        let dummyKeychainKey = "au.com.addisonbrown.api.dummay.key"
        let dummyKeychainSecret = "au.com.addisonbrown.api.dummay.secret"
        
        let apiKeyWasSet = Keychain.set(dummyKeychainKey, value: apiKey)
        let apiSecretWasSet = Keychain.set(dummyKeychainSecret, value: apiSecret)
        
        XCTAssertTrue(apiKeyWasSet, "set api key value with string in Keychain")
        XCTAssertTrue(apiSecretWasSet, "set api secret value with string in Keychain")
        
        let getApiKey = Keychain.get(dummyKeychainKey)
        let getApiSecret = Keychain.get(dummyKeychainSecret)
        
        XCTAssertNotNil(getApiKey, "retrieve api key from keychain")
        XCTAssertNotNil(getApiSecret, "retrieve api secret from keychain")
        
        XCTAssertEqual(getApiKey!, apiKey, "retrieved api key value from keychain matches raw string")
        XCTAssertEqual(getApiSecret!, apiSecret, "retrieved api secret value from keychain matches raw string")
    }
    
    func testReadingBtcMarketsKeysFromKeyChain()
    {
        //XCTAssertNotNil(BTCMarketsRouter.apiKey!.key)
        //XCTAssertNotNil(BTCMarketsRouter.apiKey!.secret)
        
        btcMarkets.setApiKeysFromKeychain()
        
        XCTAssertNotNil(BTCMarketsRouter.apiKey!.key)
        XCTAssertNotNil(BTCMarketsRouter.apiKey!.secret)
    }
    
    func testReadingBitfinexKeysFromKeyChain()
    {
        XCTAssertNotNil(BitfinexRouter.apiKey!.key)
        XCTAssertNotNil(BitfinexRouter.apiKey!.secret)
        
        bitfinex.setApiKeysFromKeychain()
        
        XCTAssertNotNil(BitfinexRouter.apiKey!.key)
        XCTAssertNotNil(BitfinexRouter.apiKey!.secret)
    }
}