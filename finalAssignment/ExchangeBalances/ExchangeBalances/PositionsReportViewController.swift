//
//  PositionsReportViewController.swift
//  ExchangeBalances
//
//  Created by Nicholas Addison on 8/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class PositionsReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of rows in the section.
        return totalAmounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("totalsDescriptionCell", forIndexPath: indexPath) as TotalsDescriptionCell
        
        let row = indexPath.row
        
        // Configure the cell...
        cell.amountDescriptionField.text = totalAmounts[indexPath.row].description
        cell.usdAmountField.text = String(format:"%g", totalAmounts[indexPath.row].currencyTotals["USD"]!)
        cell.audAmountField.text = String(format:"%g", totalAmounts[indexPath.row].currencyTotals["AUD"]!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("totalsHeaderCell") as HeaderCell
        
        return headerCell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
