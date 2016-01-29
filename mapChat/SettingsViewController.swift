//
//  SettingsViewController.swift
//  mapChat
//
//  Created by Yan Xia on 12/14/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBAction func logoutButton(sender: AnyObject) {
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = myStoryBoard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
        FirebaseHelper.logOut()
    }
    
    
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        self.userName.text = Me.account.name
    }
}
