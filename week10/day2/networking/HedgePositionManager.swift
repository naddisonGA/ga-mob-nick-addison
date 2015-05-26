//
//  HedgePositions.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

class HedgePositionManager
{
    private var _hedgePositions = [HedgePosition]()
    
    static let sharedHedgePositionManager = HedgePositionManager()
    
    func aggregatedQuantity(ofAssetCode assetCode: String) -> Double
    {
        // sum the balance property
        let aggregatedQuantity: Double = self._hedgePositions
            .map {
                //FIXME: needs to be a base asset of the instrument - not the instrumentCode
                if $0.baseAssetCode == assetCode {
                    return $0.quantity
                }
                else {
                    return 0
                }
            }
            .reduce(0) {return $0 + $1}
        
        return aggregatedQuantity
    }
    
    func hedgePositions() -> [HedgePosition]
    {
        return _hedgePositions
    }
    
    func query(callback: (hedgePositions: [HedgePosition], error: NSError?) -> ())
    {
        var query = HedgePosition.query()!
        
        query.whereKey("open", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self._hedgePositions = objects as! [HedgePosition]
                    
                    NSLog("Successfully retrieved \(self._hedgePositions.count) open hedge positions.")
                }
                else
                {
                    NSLog("Error: \(error!) \(error!.userInfo!)")
                    
                    // set the array of bank balances to an empty array
                    self._hedgePositions = [HedgePosition]()
                }
                
                // return the bank balances or error through the callback
                callback(hedgePositions: self._hedgePositions, error: error)
        }
    }
}