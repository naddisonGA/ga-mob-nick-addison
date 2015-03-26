//
//  Balance.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// Balance is used to measure the amount of an asset in an account on an exchange
public struct Balance
{
    public var total: Double = 0
    
    // the toal amount less any pending order sell amounts
    public var available: Double = 0
}