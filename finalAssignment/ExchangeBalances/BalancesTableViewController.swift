//
//  BalancesTableViewController.swift
//  ExchangeBalances
//
//  Created by Nicholas Addison on 7/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class BalancesTableViewController: UITableViewController
{

    struct Balance
    {
        var currency: String
        var total: Double = 0.0
        var available: Double = 0.0
    }
    
    struct Exchange {
        var name: String
        var balances = [Balance]()
    }
    
    var exchangeBalances = [
        Exchange(name: "BTC Markets",
            balances: [
                Balance(currency: "BTC", total: 5.5, available: 2.2),
                Balance(currency: "AUD", total: 12343.21, available: 0.01),
                Balance(currency: "LTC", total: 0, available: 0)
            ]
        ),
        
        Exchange(name: "Bitfinex",
            balances: [
                Balance(currency: "BTC", total: 10.12345678, available: 9.87654321),
                Balance(currency: "USD", total: 21456.78, available: 19876.54)
            ]
        )
        
    ]
    
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return exchangeBalances.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return exchangeBalances[section].balances.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("balanceCell", forIndexPath: indexPath) as BalanceCell

        let row = indexPath.row
        
        // Configure the cell...
        cell.currencyField.text = exchangeBalances[indexPath.section].balances[indexPath.row].currency
        cell.totalAmountField.text = String(format:"%g", exchangeBalances[indexPath.section].balances[indexPath.row].total)
        cell.availableAmountField.text = String(format:"%g", exchangeBalances[indexPath.section].balances[indexPath.row].available)

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as HeaderCell
        
        headerCell.exchangeLabel.text = exchangeBalances[section].name;
        
        NSLog("header lable text = \(exchangeBalances[section].name)")
        
        return headerCell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
