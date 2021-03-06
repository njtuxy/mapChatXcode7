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
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
    }

//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("click :")
//        print(indexPath.section)        
//        print(indexPath.row)
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userName.text = Me.account.name
        self.profilePhoto.image = Me.account.profilePhoto
        self.userEmail.text = Me.account.email
    }
}
