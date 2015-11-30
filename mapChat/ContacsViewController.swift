//
//  ContacsViewController.swift
//  
//
//  Created by Yan Xia on 11/30/15.
//
//

import UIKit



class ContacsViewController: UITableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactListItem", forIndexPath: indexPath)
        
        // Configure the cell...
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = String(indexPath.row)
        return cell
    }
    
}
