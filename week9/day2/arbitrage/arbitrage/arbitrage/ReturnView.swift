//
//  ReturnView.swift
//  arbitrage
//
//  Created by Nicholas Addison on 25/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

@IBDesignable
class ReturnView: UIView
{
    // MARK: Properties
    @IBInspectable var assetName: String? {
        didSet {
            assetNameField.text = assetName
        }
    }
    
    @IBInspectable var amount: Double? {
        didSet {
            if let amount = amount {
                amountField.text = String(format: "%.2f", amount)

            } else {
                amountField.text = nil
            }
        }
    }
    
    @IBInspectable var percentage: Double? {
        didSet {
            if let percentage = percentage {
                percentageField.text = String(format: "%.2f%", percentage)
                
            } else {
                percentageField.text = nil
            }
        }
    }
    
    // MARK: Outlets

    @IBOutlet weak var amountField: UILabel!
    @IBOutlet weak var assetNameField: UILabel!
    @IBOutlet weak var percentageField: UILabel!
    
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
        let nib = UINib(nibName: "ReturnView", bundle: bundle)
        
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
