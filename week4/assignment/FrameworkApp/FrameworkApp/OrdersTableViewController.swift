//
//  OrdersTableViewController.swift
//  FrameworkApp
//
//  Created by Nicholas Addison on 17/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orders = testOrders
    
    // MARK: - Getters
    
    var sellOrders: [Order] {
        return orders.filter() {return $0.side == .Sell}
    }
    
    var buyOrders: [Order] {
        return orders.filter() {return $0.side == .Buy}
    }
    
    // MARK: - Initializers
    
    func initOrders()
    {
        //self.orders = testOrders
        //testOrders.addTrade(Trade(exchange: btcMarkets, instrument: BTCAUD, type: .Limit, side: .Sell, amount: 10, price: 480))
        testOrders[0].addTrade(480, amount: 1)
        testOrders[0].addTrade(481, amount: 1)
        testOrders[1].addTrade(491, amount: 2.1)
        testOrders[2].addTrade(500, amount: 3.1)
        testOrders[2].addTrade(500, amount: 3.1)
        testOrders[3].addTrade(500, amount: 3.1)
        testOrders[4].addTrade(500, amount: 3.1)
        testOrders[4].addTrade(500, amount: 3.1)
        testOrders[5].addTrade(299, amount: 1)
        testOrders[5].addTrade(299, amount: 2)
        testOrders[5].addTrade(298, amount: 3.3)
        testOrders[5].addTrade(285, amount: 5)
        testOrders[6].addTrade(280, amount: 8)
        testOrders[7].addTrade(300, amount: 4)
    }
    
    override init()
    {
        super.init()
        initOrders()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initOrders()
    }
    
    // MARK: Actions
    
    @IBAction func unwindToOrdersTableViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Views
    
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
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // first section is for sell orders
        if (section == 0)
        {
            return sellOrders.count
        }
        // second section is for buy orders
        else
        {
            return buyOrders.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        var order: Order
        
        // if sell orders section
        if (indexPath.section == 0)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("sellOrderCell", forIndexPath: indexPath) as UITableViewCell
            
            order = sellOrders[indexPath.row]
        }
        else
        {
            cell = tableView.dequeueReusableCellWithIdentifier("buyOrderCell", forIndexPath: indexPath) as UITableViewCell
            
            order = buyOrders[indexPath.row]
        }
        
        cell.textLabel!.text = "price \(order.price!), outstanding \(order.amountOutstanding) state \(order.state.toString)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("Tapped - section \(indexPath.section) row \(indexPath).row)");
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        var selectedIndexPath = tableView.indexPathForSelectedRow()!
        
        // if selecting a sell order
        if (selectedIndexPath.section == 0)
        {
            var detailOrder: Order?
            detailOrder = self.sellOrders[selectedIndexPath.row]
            //detailOrder = self.sellOrders[0]
            
            (segue.destinationViewController as TradesTableViewController).order = detailOrder
        }
        // else selecting a buy order
        else if (selectedIndexPath.section == 1)
        {
            (segue.destinationViewController as TradesTableViewController).order = buyOrders[selectedIndexPath.row]
        }
    }
    

}
