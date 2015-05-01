//
//  ViewController.swift
//  networking
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btcMarkets.getTicker(BTCAUD) {(ticker, error) in
            
            if let bid = ticker?.bid
            {
                let bidString = String(format: "%f", bid)
                println("bid \(bidString) timestamp \(ticker?.timestamp)")
            }
            
        }
        
        btcMarkets.getOrderBook(BTCAUD) {(orderBook, error) in
            
            if let firstBid = orderBook?.bids.first
            {
                let bidPriceStr = String(format: "%f", firstBid.price)
                let bidQtyStr = String(format: "%f", firstBid.quantity)
                println("first bid price \(bidPriceStr) quantity \(bidQtyStr)")
            }
            
            if let thirdAsk = orderBook?.asks[2]
            {
                let thirdAskString = String(format: "%f", thirdAsk.price)
                let thirdAskQtyStr = String(format: "%f", thirdAsk.quantity)
                println("first ask price \(thirdAskString) quantity \(thirdAskQtyStr)")
            }
        }
        
        btcMarkets.getTrades(BTCAUD) {(trades, error) in
            NSLog("getTrades callback")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

