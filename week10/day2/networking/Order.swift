//
//  Order.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation


// allowed order states
public enum OrderState {
    case Pending    // order is waiting to be placed on the market
    case Open       // order has ben placed on the market
    case Cancelled  // order has been removed from the market
    case PartiallyFilled    // order is still open on the exchange but has been partially filled
    case CancelledPartiallyFilled   // order was cancelled after it was partially filled
    case Filled     // order has been fully filled with no outstanding amount
    
    var toString: String {
        switch self {
        case .Pending: return "pending"
        case .Open: return "open"
        case .Cancelled: return "cancelled"
        case .PartiallyFilled: return "partially filled"
        case .CancelledPartiallyFilled: return "cancelled after being partially filled"
        case .Filled: return "filled"
        }
    }
}

// represents an order on a market, which is an instrument on an exchange
public class Order: OrderAbstract
{
    // MARK: - Properties
    
    public let originalAmount: Double
    public var amountOutstanding: Double
    
    public var takeProfit: Double?
    public var stopLoss: Double?
    
    // unique order identifier assigned by the exchange when the order is put onto a market
    // is optional as the exchangeId is only known once the order is in open state on the market.
    // The exchangeId is not known in Pending state
    // the exchangeId can only be set by the open(exchangeId) method
    private var _exchangeId: String?
    
    // is a private property as the state transisions are constrolled through transission methods
    private var _state = OrderState.Pending
    
    // price doesn't need to be set for Market orders. It does for Limit orders
    public var price: Double? = nil
    
    // user to identify an order outside the exchange. can be an identifier assigned by the client/agent or a description
    public let tag: String? = nil
    
    // trades that have filled this order
    private var _trades = [Trade]()
    
    // MARK: - Initializer
    
    init (exchange: Exchange, instrument: Instrument, type: OrderType, side: OrderSide, amount: Double, price: Double?)
    {
        self.originalAmount = amount
        self.amountOutstanding = amount
        
        self.price = price
        
        super.init(exchange: exchange, instrument: instrument, type: type, side: side)
    }
    
    // MARK: - Getters
    
    // getter for the volume weighted average price of the trades that have filled this order
    public var vwap: Double
        {
            var sumQuantityTimesPrice: Double = 0
            var sumQuantity: Double = 0
            
            for trade in self._trades
            {
                sumQuantity += trade.quantity
                sumQuantityTimesPrice += trade.quantity * trade.price
            }
            
            return sumQuantityTimesPrice / sumQuantity
    }
    
    public var trades: [Trade]
        {
            return _trades
    }
    
    // getter for order state
    // order state can only be changed via methods like addTrade and cancel
    public var state: OrderState
        {
            return self._state
    }
    
    // _exchangeId can only be set in the open state transission function
    public var exchangeId: String?
        {
            return self._exchangeId
    }
    
    // MARK: - State transission
    
    // State transission functions
    public func open(exchangeId: String) -> NSError?
    {
        if self._state == OrderState.Pending
        {
            self._exchangeId = exchangeId
            
            self._state = OrderState.Open
            
            return nil
        }
        else
        {
            let error = Error(code: Errors.OrderOpen.rawValue,
                userInfo: [
                    NSLocalizedDescriptionKey: "Can not open order with exchange identifier \(exchangeId) in state \(self._state)",
                    NSLocalizedFailureReasonErrorKey: "An order has to be in a Pending state for it to be openned."])
            
            NSLog(error.debugDescription)
            return error
        }
    }
    
    // adds an executed trade to the order and then updates the state
    public func addTrade(price: Double, quantity: Double) -> NSError?
    {
        var trade = Trade(exchange: exchange, instrument: instrument, type: type, side: side, quantity: quantity, price: price)
        
        self._trades.append(trade)
        
        if self.amountFilled <= 0
        {
            self._state = .Filled
        }
        else
        {
            self._state = .PartiallyFilled
        }
        
        return nil
    }
    
    public func cancel() -> NSError?
    {
        switch self._state {
            
        case .PartiallyFilled:
            self._state = .CancelledPartiallyFilled
            return nil
            
        case .Open:
            self._state = .Cancelled
            return nil
            
        default:
            let error = Error(code: Errors.OrderCancel.rawValue,
                userInfo: [
                    NSLocalizedDescriptionKey: "Can not cancel order with in state \(self._state)",
                    NSLocalizedFailureReasonErrorKey: "An order has to be in an Open or PartiallyFilled state for it to be cancelled."])
            
            NSLog(error.debugDescription)
            return error
        }
    }
    
    // MARK: - Helper functions
    
    // has the order been partially filled or fuly filled?
    public var isFilled: Bool
        {
            // if the trades is empty then order has not been filled
            return !_trades.isEmpty
    }
    
    // getter of the amounts in the filled trades
    public var amountFilled: Double
        {
            // sum the amounts of all the filled trades
            return _trades.reduce(0) {$0 + $1.quantity}
    }
    
    public var amountFilledLast: Double
        {
            if _trades.isEmpty
            {
                return _trades.last!.quantity
            }
            else
            {
                return 0
            }
    }
    
    public var isLive: Bool
        {
            switch self._state {
                
            case .Open, .PartiallyFilled :
                return true
                
            default:
                return false
            }
    }
}