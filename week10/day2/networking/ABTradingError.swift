//
//  Errors.swift
//  FrameworkApp
//
//  Created by Nicholas Addison on 13/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

// Addison Brown Trading Errors
enum ABTradingError
{
    static let domain = "ABTrading"
    
    case Default
    case Create(String)
    case CreateWithReason(String, String)
    case Order_Open_StateNotPending(String, String?, OrderState)
    case Order_Cancel_StateNotOpenOrPartiallyFilled(Order)
    case OrderBook_GetVwap_InvalidRequiredAmount(Double)
    case OrderBook_GetVwap_NotEnoughInOrderBook(Double, Double)
    case OrderAddTradeInvaidExchange()
    case OrderAddTradeInvaidInstrument()
    case MethodNotImplemented
    
    var code: Int
    {
        switch self {
        case Default:
            return 1
        case Create:
            return 2
        case CreateWithReason:
            return 3
        case Order_Open_StateNotPending:
            return 101010
        case Order_Cancel_StateNotOpenOrPartiallyFilled:
            return 102010
        case OrderBook_GetVwap_InvalidRequiredAmount:
            return 301001
        case OrderBook_GetVwap_NotEnoughInOrderBook:
            return 301002
        case OrderAddTradeInvaidExchange:
            return 50
        case OrderAddTradeInvaidInstrument:
            return 60
        case MethodNotImplemented:
            return 999999
        default:
            return 100000 }
    }
    
    var error: NSError
    {
        var description = "Error in the Trading Platform framework"
        var failureReason = "Unknown reason for failure"
        
        switch self {
            
        case Create(let descriptionParam):
            description = descriptionParam
            
        case CreateWithReason(let descriptionParam, let failureReasonParam):
            description = descriptionParam
            failureReason = failureReasonParam 
            
        case OrderBook_GetVwap_InvalidRequiredAmount(let requiredAmount):
            description = "Required amount \(requiredAmount) must be greater than 0"
            
        case Order_Cancel_StateNotOpenOrPartiallyFilled(let order):
            description = "Can not cancel order on \(order.exchange.name) with id \(order.exchangeId) in state \(order.state)"
            failureReason = "An order has to be in an Open or PartiallyFilled state for it to be cancelled."
            
        case Order_Open_StateNotPending(let exchangeName, let exchangeId, let state):
            description = "Can not open order on \(exchangeName) with id \(exchangeId) in state \(state)"
            failureReason = "An order has to be in a Pending state for it to be openned"
            
        case OrderBook_GetVwap_NotEnoughInOrderBook(let requiredAmount, let sumAmount):
            description = "Not enough orders in the order book to calculate volume weighted average price for required amount \(requiredAmount)"
            failureReason = "Only \(sumAmount) total amount in the order book"
            
        case .MethodNotImplemented:
            description = "Method has not been implemented"
            
        default:
            break
        }
        
        return NSError(
            domain: ABTradingError.domain,
            code: code,
            userInfo: [
                NSLocalizedDescriptionKey: description,
                NSLocalizedFailureReasonErrorKey: failureReason])
    }
}