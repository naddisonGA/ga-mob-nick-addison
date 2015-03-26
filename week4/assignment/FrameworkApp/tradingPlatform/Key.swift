//
//  Key.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// stored API access information
public struct Key
{
    public let key: String
    public let secret: String
    
    // some exchanges give a unique identifier to the API keys on their exchange
    public let id: String?
    
    // some exchanges allow the user to give a name/description of their key
    public let name: String?
    
    // MARK: - initializer
    
    init (key: String, secret: String)
    {
        self.key = key
        self.secret = secret
    }
}