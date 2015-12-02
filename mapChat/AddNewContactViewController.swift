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

    //    var user_email_array = [[String:String]]()
    //    var user_uid_array = [String]()
    //    var email_uid_pairs = [String: String]()
    
    struct User {
        var uid: String
        var email: String
    }
    
    var usersArray = [User]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactListItem", forIndexPath: indexPath)
        
        let index = indexPath.row
        // Configure the cell...
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = self.usersArray[index].email
        
        
//        let button = cell.viewWithTag(1002) as! UIButton
//        button.tag = index
//        button.addTarget(self, action: "addThisUser:", forControlEvents: .TouchUpInside)
        
        return cell
        
    }
    
    override func viewDidLoad() {
        print("view loaded")
        //        getAllUsersFromFirebase()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        
        var t_usersArray = [User]()
        
//        users.queryOrderedByChild("uid").observeEventType(.ChildAdded, withBlock: { snapshot in
//            for item in snapshot.children{
//                let user = item as! FDataSnapshot
//                let email = user.value
//                let key = user.key
//                
//            }
//            
//            self.user_email_list = t_list
//            self.tableView.reloadData()
//        })

        users.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
            
            if let email = snapshot.value["email"] as? String {
                if let uid = snapshot.value["uid"]{
                    t_usersArray.append(User(uid: String(uid), email: email))
                }
            }
            self.usersArray = t_usersArray
            self.tableView.reloadData()
        })

        
//        
//        users.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
//            for item in snapshot.children{
//                let contact = item as! FDataSnapshot
//                let email = contact.value as? String
//                t_list.append(email!)
//            }
//            
//            self.user_email_list = t_list
//            self.tableView.reloadData()
//
//            
//        })
        
        
    }
    
    
//    func addThisUser(sender: UIButton){
//        print(sender.tag)
//        print(user_email_array[sender.tag])
//        sender.setTitle("sent", forState: .Normal)
//    }
//    
//    func addUserToMyContactList(){
//        
//    }
    

    

    
}
