//
//  AddNewContactViewController.swift
//  mapChat
//
//  Created by Yan Xia on 12/1/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase

class AddNewContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var contactsTable: UITableView!
    
    //    var user_email_array = [[String:String]]()
    //    var user_uid_array = [String]()
    //    var email_uid_pairs = [String: String]()
    
    struct User {
        var uid: String!
        var email: String!
    }
    
    var usersArray = [User]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewContactListItem", forIndexPath: indexPath) as! NewContactTableViewCell
        
        let index = indexPath.row
        // Configure the cell...
        cell.txtUserEmail.text = self.usersArray[index].email
        cell.btnAddContact.tag = index
        cell.btnAddContact.addTarget(self, action: "addThisUser:", forControlEvents: .TouchUpInside)
        
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
                if let uid = snapshot.value["uid"] as? String {
                    t_usersArray.append(User(uid: uid, email: email))
                }
            }
            self.usersArray = t_usersArray
            self.contactsTable.reloadData()
        })
        
    }
    
    
    func addThisUser(sender: UIButton){
        let thisUsersUID = usersArray[sender.tag].uid
        sender.setTitle("Added", forState: .Normal)
        sender.backgroundColor = UIColor.greenColor()
        addToContactListInFirebase(thisUsersUID)
    }

    func addToContactListInFirebase(uidOfNewContact: String){
        let uid = FirebaseHelper.readUidFromNSUserDefaults()
        let contacts = FirebaseHelper.myRootRef.childByAppendingPath("contacts").childByAppendingPath(uid)
        let new_contact = [uidOfNewContact: "true"]
        contacts.updateChildValues(new_contact)
    }
    
    

    

    
}
