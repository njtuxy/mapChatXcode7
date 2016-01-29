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
    
    struct User {
        let uid: String!
        let email: String!
        let contacts: [String]!
        
        init(snapShot: FDataSnapshot){
            let value = snapShot.value
            uid = value["uid"] as! String
            email = value["email"] as! String
            contacts = []
        }
    }
    
    var strangerList = [User]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strangerList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewContactListItem", forIndexPath: indexPath) as! NewContactTableViewCell
        
        cell.selectionStyle = .None
        
        let index = indexPath.row

        // Configure the cell...
        cell.txtUserEmail.text = self.strangerList[index].email
        cell.btnAddContact.tag = index
        cell.btnAddContact.addTarget(self, action: "addThisUser:", forControlEvents: .TouchUpInside)
        return cell
        
    }
    
    
    override func viewDidLoad() {
        
        let myUid = Me.account.uid
        let users = FirebaseHelper.rootRef.childByAppendingPath("users")

        var t_strangers_list = [User]()
        

        //Add observer to the users list, order by UID, and listen to ChildAdded Event
        users.queryOrderedByChild("uid").observeEventType(.ChildAdded, withBlock: { usersSnapShot in
            
            if let uidOfStranger = usersSnapShot.value["uid"] as? String {
                
                //Make sure it is not myself
                if(uidOfStranger != myUid){
                    
                    //Check this stranger's children
                    let contactsOfStranger = users.childByAppendingPath(uidOfStranger).childByAppendingPath("contacts").childByAppendingPath(myUid)
                    
                    //Check whether the contacts node exisits
                    contactsOfStranger.observeEventType(.Value, withBlock: { contactsSnapShot in
                        
                        //If not exists, it means it is not my contact, then show it on the stangers screen
                        if !contactsSnapShot.exists() {
                            let user_item = User(snapShot: usersSnapShot)
                            t_strangers_list.append(user_item)
                        }
                        
                        self.strangerList = t_strangers_list
                        self.contactsTable.reloadData()

                    })
                }
            }
        })        
    }
    
    
    func addThisUser(sender: UIButton){
        let thisUsersUID = strangerList[sender.tag].uid
        addToContactListInFirebase(thisUsersUID, indexInTable: sender.tag)
        sender.setTitle("Added", forState: .Normal)
        sender.backgroundColor = UIColor.greenColor()
        self.contactsTable.reloadData()
    }
    
    

    func addToContactListInFirebase(uidOfStranger: String, indexInTable: Int){
        let myUid = Me.account.uid
        let users = FirebaseHelper.rootRef.childByAppendingPath("users")
        //Save the stranger's UID to current user's node
        
        let contactListOfCurrentUser = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(uidOfStranger)
        contactListOfCurrentUser.setValue(false)
        

        //Save current user's UID to stranger's node.
        let contactListOfStanger = users.childByAppendingPath(uidOfStranger).childByAppendingPath("contacts").childByAppendingPath(myUid)
        contactListOfStanger.setValue(false)
    }
    
}
