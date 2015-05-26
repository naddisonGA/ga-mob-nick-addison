//
//  Transfers.swift
//  exposures
//
//  Created by Nicholas Addison on 29/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class TransferManager
{
    private var _transfers = [Transfer]()
    
    static let sharedTransferManager = TransferManager()
    
    func aggregatedQuantity(ofAssetCode assetCode: String) -> Double
    {
        // sum the balance property
        let aggregatedQuantity: Double = self._transfers
            .map {
                if $0.assetCode == assetCode {
                    return $0.quantity
                }
                else {
                    return 0
                }
            }
            .reduce(0) {return $0 + $1}
        
        return aggregatedQuantity
    }
    
    func query(callback: (transfers: [Transfer], error: NSError?) -> ())
    {
        var query = Transfer.query()!
        
        query.whereKey("cleared", equalTo: false)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self._transfers = objects as! [Transfer]
                    
                    println("Successfully retrieved \(self._transfers.count) transfers.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of transfers to an empty array
                    self._transfers = [Transfer]()
                }
                
                // return the bank balances or error through the callback
                callback(transfers: self._transfers, error: error)
        }
    }
}