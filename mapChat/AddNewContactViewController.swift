//
//  AddNewContactViewController.swift
//  mapChat
//
//  Created by Yan Xia on 12/1/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase

class AddNewContactViewController: UITableViewController {
    var user_email_list = [String]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_email_list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactListItem", forIndexPath: indexPath)
        
        let index = indexPath.row
        // Configure the cell...
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = self.user_email_list[index]
        
        let button = cell.viewWithTag(1002) as! UIButton
        button.tag = index
        button.addTarget(self, action: "addThisUser:", forControlEvents: .TouchUpInside)
        
        return cell
        
    }
    
    override func viewDidLoad() {
        print("view loaded")
        //        getAllUsersFromFirebase()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        print("in view appear method")
        var t_list = [String]()
        users.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in

            for item in snapshot.children{
                let contact = item as! FDataSnapshot
                let email = contact.value as? String
                t_list.append(email!)
            }
            
            self.user_email_list = t_list
            self.tableView.reloadData()
        })
        
        
    }
    
    
    func addThisUser(sender: UIButton){
        print(sender.tag)
    }
    
    //    func getAllUsersFromFirebase(){
    //        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
    //        print("in get all users method")
    //        users.queryOrderedByChild("email").observeEventType(.Value, withBlock: { snapshot in
    //            if let email = snapshot.value["email"] as? String {
    //                self.user_email_list.append(email)
    //                self.tableView.reloadData()
    //                print(self.user_email_list)
    //            }
    //        })
    //    }
    

    
}
