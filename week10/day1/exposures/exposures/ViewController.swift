//
//  ViewController.swift
//  exposures
//
//  Created by Nicholas Addison on 28/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController
{
    var exchangeBalances = ExchangeBalances()
    var bankBalances = BankBalances()
    var transfers = Transfers()
    
    var exposures = Exposures()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        exposures.query {(error: NSError?) in
            NSLog("completed all 4 queries")
        }
        
        /*
        bankBalances.query {(bankBalances: [BankBalance], error: NSError?) in
        
            println("count of bank balances \(bankBalances.count)")
            
            if let firstBankBalance = bankBalances.first
            {
                println("bank name of first balance \(firstBankBalance.institutionName)")
            }
            
            for bankBalance in bankBalances
            {
                println("bank balance object Id \(bankBalance.objectId!) asset name \(bankBalance.assetName) available \(bankBalance.available)")
            }
        }
        
        exchangeBalances.query {(exchangeBalances: [ExchangeBalance], error: NSError?) in
            
            println("count of bank balances \(exchangeBalances.count)")
            
            if let firstExchangeBalance = exchangeBalances.first
            {
                println("bank name of first balance \(firstExchangeBalance.institutionName)")
            }
            
            for exchangeBalance in exchangeBalances
            {
                println("bank balance object Id \(exchangeBalance.objectId!) asset name \(exchangeBalance.assetName) available \(exchangeBalance.available)")
            }
        }
        
        transfers.query {(transfers: [Transfer], error: NSError?) in
            
            println("count of transfers \(transfers.count)")
            
            for transfer in transfers
            {
                println("transfer object Id \(transfer.objectId!) \(transfer.cleared) from \(transfer.fromEntity) to \(transfer.toEntity) \(transfer.quantity) \(transfer.assetName)")
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

