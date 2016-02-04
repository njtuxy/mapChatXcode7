//
//  ProfileTableViewController.swift
//  mapChat
//
//  Created by Yan Xia on 2/2/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController{

    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.profilePhoto.image = Me.account.profilePhoto.circle2
        self.userName.text = Me.account.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}





