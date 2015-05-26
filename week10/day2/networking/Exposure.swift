//
//  Exposure.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

struct Exposure
{
    let asset: Asset
    
    let longPosition: Double
    let shortPosition: Double
    
    var amount: Double
    {
        return longPosition - shortPosition
    }
    
    var decimal: Double
    {
        if longPosition == 0
        {
            return -shortPosition
        }
        else
        {
            return amount / longPosition
        }
    }
    
    var percentage: Double
    {
            return decimal * 100
    }
}