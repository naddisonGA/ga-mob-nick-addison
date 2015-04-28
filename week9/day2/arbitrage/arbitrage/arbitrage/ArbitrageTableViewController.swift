//
//  ArbitrageTableViewController.swift
//  arbitrage
//
//  Created by Nicholas Addison on 23/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ArbitrageTableViewController: PFQueryTableViewController
{
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.parseClassName = "BlogPost"
        //"Arbitrage.parseClassName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: tableView
    
    override func queryForTable() -> PFQuery
    {
        var query = Arbitrage.query()!
        query.includeKey("sellTrade")
        query.includeKey("buyTrade")
        query.orderByDescending("timestamp")
        
        return query
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! ArbitrageHeaderCell
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("arbitrageCell") as! ArbitrageCell
        
        let arbitrage = object as! Arbitrage
        
        if let timestamp = arbitrage.timestamp
        {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            cell.timeField.text = dateFormatter.stringFromDate(timestamp)
        }
        
        cell.exchangeRateField.text = String(format:"%.3f", arbitrage.variableExchangeRate)
        
        if let returnPercentage = arbitrage.arbReturn?.percentage
        {
            cell.returnPercentageField.text = String(format:"%.2f%", returnPercentage)
        }
        else
        {
            cell.returnPercentageField.text = nil
        }
        
        if let returnQuantity = arbitrage.arbReturn?.amount(.Buy)
        {
            cell.variableBuyAmountField.text = String(format:"%.2f%", returnQuantity)
        }
        else
        {
            cell.variableBuyAmountField.text = nil
        }
        
        if let returnQuantity = arbitrage.arbReturn?.amount(.Sell)
        {
            cell.variableSellAmountField.text = String(format:"%.2f%", returnQuantity)
        }
        else
        {
            cell.variableSellAmountField.text = nil
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "arbDetails"
        {
            let destinationViewController = segue.destinationViewController as? ArbitrageDetailsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow()
            {
                let objectForSelectedRow = objectAtIndexPath(indexPath)
                destinationViewController!.arbitrage = objectForSelectedRow as? Arbitrage
            }
        }
    }
}

