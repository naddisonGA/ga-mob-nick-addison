//
//  Trade.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

// represents an executed trade on a market, which is an instrument on an exchange
// an order can have many executed trades at different amounts and prices
public class Trade: OrderAbstract
{
    public let price: Double
    public let quantity: Double
    
    // MARK: - initializer
    
    init (exchange: Exchange, instrument: Instrument, type: OrderType, side: OrderSide, quantity: Double, price: Double)
    {
        self.price = price
        self.quantity = quantity
        
        super.init(exchange: exchange, instrument: instrument, type: type, side: side)
    }
}
