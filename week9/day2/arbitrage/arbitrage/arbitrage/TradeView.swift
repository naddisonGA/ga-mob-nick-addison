//
//  TradeView.swift
//  arbitrage
//
//  Created by Nicholas Addison on 24/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

@IBDesignable
class TradeView: UIView
{

    // MARK: properties
    
    @IBInspectable var exchangeName: String? {
        didSet {
            exchangeNameField.text = exchangeName
        }
    }
    
    @IBInspectable var instrumentName: String? {
        didSet {
            instrumentNameField.text = instrumentName
        }
    }
    
    @IBInspectable var price: Double? {
        didSet {
            if let price = price {
                priceField.text = String(format: "%f", price)
            }
            else
            {
                priceField.text = nil
            }
        }
    }
    
    @IBInspectable var quantity: Double? {
        didSet {
            if let quantity = quantity {
                quantityField.text = String(format: "%f", quantity)
            }
            else
            {
                quantityField.text = nil
            }
        }
    }
    
    @IBInspectable var type: String? {
        didSet {
            typeField.text = type
        }
    }
    
    @IBInspectable var timestamp: NSDate? {
        didSet
        {
            if let timestamp = timestamp
            {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                
                timestampField.text = dateFormatter.stringFromDate(timestamp)
            }
            else
            {
                timestampField.text = nil
            }
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var exchangeNameField: UILabel!
    @IBOutlet weak var instrumentNameField: UILabel!
    @IBOutlet weak var priceField: UILabel!
    @IBOutlet weak var quantityField: UILabel!
    @IBOutlet weak var typeField: UILabel!
    @IBOutlet weak var timestampField: UILabel!
    
    // MARK: Standard custom UIView code
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TradeView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect){
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
}
