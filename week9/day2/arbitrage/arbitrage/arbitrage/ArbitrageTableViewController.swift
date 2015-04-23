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
        
        let cellIdentifier = "arbitrageCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ArbitrageCell
        
        let arbitrage = object as! Arbitrage
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm" //format style. Browse online to get a format that fits your needs.
        
        if let timestamp = arbitrage.timestamp
        {
            cell.timeField.text = dateFormatter.stringFromDate(timestamp)
        }
        
        cell.exchangeRateField.text = String(format:"%.3f", arbitrage.variableExchangeRate)
        
        if let arbReturn = arbitrage.arbReturn
        {
            cell.returnPercentageField.text = String(format:"%.2f%", arbReturn.percentage)
            cell.variableBuyAmountField.text = String(format:"%.2f%", arbReturn.amount("USD"))
            cell.variableSellAmountField.text = String(format:"%.2f%", arbReturn.amount("AUD"))
        }
        else
        {
            cell.returnPercentageField.text = nil
            cell.variableBuyAmountField.text = nil
            cell.variableSellAmountField.text = nil
        }
        
        return cell
    }
    
}
