//
//  ExchangeBalancesTableViewController.swift
//  
//
//  Created by Nicholas Addison on 8/05/2015.
//
//

import UIKit

class ExchangeBalancesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("getAllBalances"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        getAllBalances()
    }
    
    // gets the balances from all the configured exchanges
    func getAllBalances()
    {
        self.refreshControl?.beginRefreshing()
        var completedTasks = 0
        
        //TODO: async.parallel
        ExchangeManager.sharedExchangeManager.getAllBalances
        {
            erorr in
            
            //FIXME: display error
            //self.UIAlertController()
            
            self.tableView.reloadData()
            
            if ++completedTasks >= 2
            {
                self.refreshControl?.endRefreshing()
            }
        }
        
        AssetExchanger.sharedAssetExchanger.updateTickers()
        {
            error in
            
            //FIXME: display error
            
            self.tableView.reloadData()
            
            if ++completedTasks >= 2
            {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        // need a section for each exchange plus one more for the grand totals at the top
        return ExchangeManager.sharedExchangeManager.exchanges.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        switch section {
            case 0:
                // the first section is for the grand totals which will only have one row
                return 1
            
            default:
                if let exchangeCurrenciesCount = ExchangeManager.sharedExchangeManager.exchanges[section - 1].accounts.first?.balances.count
                {
                    return exchangeCurrenciesCount + 1
                }
                else
                {
                    return 0
                }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("exchangeBalancesTotalsCell", forIndexPath: indexPath) as! ExchangeBalancesTotalTableViewCell
            
            let (audTotal, error) = ExchangeManager.sharedExchangeManager.totalBalance(AUD)
            
            if let audTotal = audTotal
            {
                cell.audTotalField.text = String(format: "%.2f", audTotal)
            }
            
            return cell
        }
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("exchangeBalancesHeaderCell", forIndexPath: indexPath) as! ExchangeBalancesHeaderTableViewCell
            
            let exchange = ExchangeManager.sharedExchangeManager.exchanges[indexPath.section - 1]
            
            cell.exchangeNameField.text = exchange.name
            
            let (audBalance, error) = exchange.summedBalances(AUD)
            
            if let audBalance = audBalance
            {
                cell.exchangeAUDTotalField.text = String(format: "%.2f", audBalance.total)
            }
            else
            {
                cell.exchangeAUDTotalField.text = nil
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("exchangeBalancesCell", forIndexPath: indexPath) as! ExchangeBalancesTableViewCell
            
            let cellBalance = ExchangeManager.sharedExchangeManager.exchanges[indexPath.section - 1].accounts.first!.balances[indexPath.row - 1]
            
            cell.currencyField.text = cellBalance.asset.code
            
            // format balance amount depending on the type of currency. ie crypto or fiat
            if (cellBalance.asset as! Currency).type == .Crypto
            {
                cell.availableField.text = String(format: "%.4f", cellBalance.available)
                cell.totalField.text = String(format: "%.4f", cellBalance.total)
            }
            else
            {
                cell.availableField.text = String(format: "%.2f", cellBalance.available)
                cell.totalField.text = String(format: "%.2f", cellBalance.total)
            }
            
            // set AUD field
            if let aud = AssetExchanger.sharedAssetExchanger.getRate(cellBalance.asset, toAsset: AUD)
            {
                cell.audField.text = String(format: "%.2f", aud * cellBalance.total)
            }
            else
            {
                cell.audField.text = nil
            }
            
            return cell
        }
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
