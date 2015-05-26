//
//  ArbitrageDetailsViewController.swift
//  arbitrage
//
//  Created by Nicholas Addison on 24/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse

class ArbitrageDetailsViewController: UIViewController
{
    var arbitrage: Arbitrage?
    
    @IBOutlet weak var returnAmountInSellExchangeQuoteCurrencyField: UILabel!
    @IBOutlet weak var returnAmountInBuyExchangeQuoteCurrencyField: UILabel!
    
    @IBOutlet weak var exchangeRateField: UILabel!
    @IBOutlet weak var invertedExchangeRateField: UILabel!
    
    @IBOutlet weak var returnAmountInSellExchangeQuoteCurrencyView: ReturnView!
    
    @IBOutlet weak var buyTradeView: TradeView!
    @IBOutlet weak var sellTradeView: TradeView!
    
    func setTradeViewProperties(#trade: TradePF?, tradeView: TradeView)
    {
        if let exchangeName = trade?.exchangeName {
            tradeView.exchangeName = exchangeName
        }
        
        if let instrumentCode = trade?.instrumentCode {
            tradeView.instrumentCode = instrumentCode
        }
        
        if let price = trade?.price {
            tradeView.price = price
        }
        
        if let quantity = trade?.quantity {
            tradeView.quantity = quantity
        }
        
        if let typeCode = trade?.typeCode {
            tradeView.type = typeCode
        }
        
        if let timestamp = trade?.timestamp {
            tradeView.timestamp = timestamp
        }
    }
    
    func setArbitrageReturnFields()
    {
        if let variableExchangeRate = arbitrage?.variableExchangeRate {
            exchangeRateField.text = String(format: "%.3f", variableExchangeRate)
            invertedExchangeRateField.text = String(format: "%.3f", 1 / variableExchangeRate)
        }
        
        if let returnAmountInSellExchangeQuoteCurrency = arbitrage?.arbReturn?.amount("AUD") {
            returnAmountInSellExchangeQuoteCurrencyField.text = String(format: "%.2f", returnAmountInSellExchangeQuoteCurrency)
        }
        
        if let returnAmountInBuyExchangeQuoteCurrency = arbitrage?.arbReturn?.amount("USD") {
            returnAmountInBuyExchangeQuoteCurrencyField.text = String(format: "%.2f", returnAmountInBuyExchangeQuoteCurrency)
        }
    }
    
    func setReturnedCurrencyViews()
    {
        returnAmountInSellExchangeQuoteCurrencyView.amount = arbitrage?.arbReturn?.amount(.Sell)
        returnAmountInSellExchangeQuoteCurrencyView.assetName = arbitrage?.arbReturn?.sellAmount?.assetName
        returnAmountInSellExchangeQuoteCurrencyView.percentage = arbitrage?.arbReturn?.percentage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setArbitrageReturnFields()
        
        setReturnedCurrencyViews()
        
        setTradeViewProperties(trade: arbitrage?.buyTrade, tradeView: buyTradeView)
        setTradeViewProperties(trade: arbitrage?.sellTrade, tradeView: sellTradeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
