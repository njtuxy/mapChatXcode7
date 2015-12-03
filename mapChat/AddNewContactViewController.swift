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
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")


        let existing_contacts = FirebaseHelper.myRootRef.childByAppendingPath("contacts").childByAppendingPath(myUid)
        
        
        existing_contacts.observeEventType(.Value, withBlock: { existing_contacts_snapshot in
            print("a got called!")
            var t_usersArray = [User]()
            users.queryOrderedByChild("uid").observeEventType(.ChildAdded, withBlock: { all_users_snapshot in
                print("b got called!")
                if let email = all_users_snapshot.value["email"] as? String {
                    if let uid = all_users_snapshot.value["uid"] as? String {
                        if(uid != myUid){
                            if existing_contacts_snapshot.exists(){
                                let value = existing_contacts_snapshot.value[uid]
                                if (value === nil) || (value as! String == "false"){
                                    t_usersArray.append(User(uid: uid, email: email))
                                }
                            }else{
                                t_usersArray.append(User(uid: uid, email: email))
                            }
                            
                            
                        }
                    }
                }
                print(t_usersArray)
                self.usersArray = t_usersArray
                self.contactsTable.reloadData()
                })

        })
        
    }
    
    
    func addThisUser(sender: UIButton){
        let thisUsersUID = usersArray[sender.tag].uid
//        sender.setTitle("Remove", forState: .Normal)
//        sender.backgroundColor = UIColor.redColor()
        addToContactListInFirebase(thisUsersUID, indexInTable: sender.tag)
        self.contactsTable.reloadData()
    }
    
    

    func addToContactListInFirebase(uidOfNewContact: String, indexInTable: Int){
        let uid = FirebaseHelper.readUidFromNSUserDefaults()
        let contacts = FirebaseHelper.myRootRef.childByAppendingPath("contacts").childByAppendingPath(uid)
        let new_contact = [uidOfNewContact: "true"]
        contacts.updateChildValues(new_contact)
//        usersArray.removeAtIndex(indexInTable)
    }
    

    

    
}
