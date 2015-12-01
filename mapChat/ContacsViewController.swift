//
//  ContacsViewController.swift
//  
//
//  Created by Yan Xia on 11/30/15.
//
//

import UIKit
import Firebase



class ContacsViewController: UITableViewController {

//    var user_email_list = [String]()
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return user_email_list.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("ContactListItem", forIndexPath: indexPath)
//        
//        // Configure the cell...
//        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = self.user_email_list[indexPath.row]
//        return cell
//        
//    }
//    
//    override func viewDidLoad() {
//        print("view loaded")
////        getAllUsersFromFirebase()
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
//        print("in view appear method")
//        var t_list = [String]()
//        users.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
////            if let email = snapshot.value["email"] as? String {
////                t_list.append(email)
////                print("...")
////                print(self.user_email_list)
////            }
//            
//            for item in snapshot.children{
//                let contact = item as! FDataSnapshot
//                let email = contact.value as? String
//                t_list.append(email!)
//            }
//            
//            self.user_email_list = t_list
//            self.tableView.reloadData()
//        })
//
//        
//    }
    
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
