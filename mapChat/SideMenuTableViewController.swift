//
//  SideMenuTableViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/24/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.blackColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont(name:"Avenir", size:15)
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
//            selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
//        cell!.textLabel?.text = "ViewController #\(indexPath.row+1)"
        cell!.textLabel?.text = "Yan Xia"
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController1")
            print("PPPPPPPP")
            break
        case 1:
//            destViewController = mainStoryboard.instfantiateViewControllerWithIdentifier("ViewController2")
            print("Finish case 1")
            break
        case 2:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController3")
            print("Finish case 2")
            break
        default:
            print("Finish case 3")
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4")
            break
        }
        
        toggleSideMenuView()
//        sideMenuController()?.setContentViewController(destViewController)

        print("Finish the loop")
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
