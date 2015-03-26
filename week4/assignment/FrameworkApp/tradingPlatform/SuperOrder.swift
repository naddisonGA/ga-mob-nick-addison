//
//  SuperOrder.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation


public enum OrderType {
    case Limit
    case Market
    case Stop
    case FillOrKill
}

public enum OrderSide {
    case Buy
    case Sell
}


public class SuperOrder
{
    public let exchange: Exchange
    public let instrument: Instrument
    
    public let type: OrderType
    public let side: OrderSide
    
    public let createdTime = NSDate()
    
    init (exchange: Exchange, instrument: Instrument, type: OrderType, side: OrderSide)
    {
        self.exchange = exchange
        self.instrument = instrument
        self.type = type
        self.side = side
    }
    
    var buyAsset: Asset
        {
            return ( self.side == .Sell ?
                self.instrument.baseAsset :
                self.instrument.quoteAsset )
        }
    
    var sellAsset: Asset
        {
            return ( self.side == .Sell ?
                self.instrument.quoteAsset :
                self.instrument.baseAsset )
    }
}