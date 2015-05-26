//
//  HedgePositions.swift
//  exposures
//
//  Created by Nicholas Addison on 30/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse

class HedgePosition: PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "HedgePositions"
    }
    
    // register this class with the Parse SDK
    override class func initialize() {
//        let baseAsset = Asset(code: self.baseAssetCode)
//        let quoteAsset = Asset(code: self.quoteAssetCode)
//        
//        self.instrument = Instrument(base: baseAsset, quote: quoteAsset)
    }
    
    @NSManaged var institutionName: String
    
    @NSManaged var baseAssetCode: String
    @NSManaged var quoteAssetCode: String
    
    @NSManaged var side: String
    
    @NSManaged var quantity: Double
    @NSManaged var price: Double
    
    @NSManaged var stopLoss: Double
    @NSManaged var takeProfit: Double
    
    @NSManaged var open: Bool
    @NSManaged var openTime: NSDate
    @NSManaged var closeTime: NSDate
    
    var instrument: Instrument?
    
    func setInstrument()
    {
        let baseAsset = Asset(code: self.baseAssetCode, name: "")
        let quoteAsset = Asset(code: self.quoteAssetCode, name: "")
        
        self.instrument = Instrument(base: baseAsset, quote: quoteAsset)
    }
    
//    override init() {
//        super.init()
//        
//        setInstrument()
//    }
}