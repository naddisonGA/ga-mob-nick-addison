//
//  AbstractExchangeRouter.swift
//  networking
//
//  Created by Nicholas Addison on 8/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

protocol AbstractExchangeRouter
{
    //MARK:- static variables
    
    static var apiKey: String? { get }
    static var apiSecret: String? { get }
}