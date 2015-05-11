//
//  Account.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// represents a user account on an exchange
public class Account
{
    // is the unique identifier for an account on an exchange
    public let username: String
    
    // code is for account/customer numbers or alpha numeric codes
    public var code: String?
    
    public var firstName: String?
    public var lastName: String?
    
    public var email: String?
    
    // an account can have multiple API keys
    // a Key object has a key string and secret
    public var apiKeys: [ApiKey] = []
    
    // The balances dictionary key is the Asset, which uses the code property to get a hashvalue. eg Currency codes AUD or BTC will be hashed
    // the following creates an empty dictionary
    public var balances = [Balance]()
    
    // MARK: - Initializers
    
    init (username: String)
    {
        self.username = username
    }
    
    init (username: String, assets: [Asset])
    {
        self.username = username
        
        // initialise the balances for each asset to 0
        for asset in assets
        {
            self.balances.append(Balance(asset: asset) )
        }
    }
    
    init (username: String, balances: [Balance])
    {
        self.username = username
        self.balances = balances
    }
}