//
//  OrderBook.swift
//  
//
//  Created by Nicholas Addison on 13/03/2015.
//
//

import Foundation

public class PriceAmount
{
    let price: Double
    let amount: Double
    
    init (price: Double, amount: Double)
    {
        self.price = price
        self.amount = amount
    }
}

enum OrderBookSide {
    case Asks
    case Bids
}

public class OrderBook
{
    var bids: [PriceAmount]
    var asks: [PriceAmount]
    
    init (bids: [PriceAmount], asks: [PriceAmount])
    {
        self.bids = bids
        self.asks = asks
    }
    
    // TODO need to implement
    func addOrder(newOrder: Order)
    {
        // if sell order then add to asks
        // else buy order then add to bids
        let orders = (newOrder.side == .Sell ?
            self.asks :
            self.bids )
        /*
        for var i = 0; i < orders.count; i++
        {
            let currentOrder = orders[i]
            
            //let nextOrder = orders[i+1]
            
            if orders[i].price == newOrder.price
            {
                //orders[i].amount += newOrder.amountOutstanding
                break
            }
        } */
    }
    func cancelOrder(order: Order) {}
    
    func getVwap(side: OrderBookSide, requiredAmount: Double) -> (Double?, NSError?)
    {
        if (requiredAmount <= 0)
        {
            let error = NSError(
                domain: domainTP,
                code: Errors.OrderBookGetVwapInvalidRequiredAmount.rawValue,
                userInfo: [
                    NSLocalizedDescriptionKey: "Invalid required amount \(requiredAmount)",
                    NSLocalizedFailureReasonErrorKey: "Required amount number be greater than 0"])
            
            NSLog(error.debugDescription)
            return (nil, error)
        }
        
        var sumAmount = 0.0
        var sumPriceTimesAmount = 0.0
        var index = 0
        
        let orders = (side == .Asks ?
            self.asks :
            self.bids)
        
        // loop through the bid or ask orders
        for order in self.asks
        {
            let oldSumAmount = sumAmount
            sumAmount += order.amount
            
            if sumAmount >= requiredAmount
            {
                let lastAmount = requiredAmount - oldSumAmount
                
                sumAmount = requiredAmount
                sumPriceTimesAmount += order.price * lastAmount
                
                break
            }
            else
            {
                sumPriceTimesAmount += order.price * order.amount
            }
        }
        
        if (sumAmount < requiredAmount)
        {
            let error = NSError(
                domain: domainTP,
                code: Errors.OrderBookGetVwapNotEnoughInOrderBook.rawValue,
                userInfo: [
                    NSLocalizedDescriptionKey: "Not enough orders in the order book to calculate volume weighted average price for required amount \(requiredAmount)",
                    NSLocalizedFailureReasonErrorKey: "Only \(sumAmount) total amount in the order book"])
            
            NSLog(error.debugDescription)
            return (nil, error)
        }
        
        let vwap = sumPriceTimesAmount / sumAmount
        
        return (vwap, nil)
    }
}