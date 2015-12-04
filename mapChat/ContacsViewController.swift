//
//  ContacsViewController.swift
//  
//
//  Created by Yan Xia on 11/30/15.
//
//

import UIKit
import Firebase



class ContacsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var allContactsTable: UITableView!
    
    struct User {
        var uid: String!
        var email: String!
    }
    
    var contactsArray = [User]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsCell", forIndexPath: indexPath) as! ContactsViewCell
        
        let index = indexPath.row
        // Configure the cell...
        cell.txtUserEmail.text = self.contactsArray[index].email
        cell.btnRemoveContact.tag = index
        cell.btnRemoveContact.addTarget(self, action: "removeThisUser:", forControlEvents: .TouchUpInside)
        return cell
        
    }
    
    
    override func viewDidLoad() {
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let existing_contacts = FirebaseHelper.myRootRef.childByAppendingPath("contacts").childByAppendingPath(myUid)
        
        var t_contactsArray = [User]()
        var t_email = String()
        
        existing_contacts.observeEventType(.ChildChanged, withBlock: { existing_contacts_snapshot in
            print("a got called")
            if existing_contacts_snapshot.exists(){
                if let status = existing_contacts_snapshot.value as? String{
                    if let uid = existing_contacts_snapshot.key{
                        if status == "true"{
                            let user = FirebaseHelper.myRootRef.childByAppendingPath("users").childByAppendingPath(uid)
                            user.observeEventType(.Value, withBlock: { existing_contacts_snapshot in
                                print("b got called")
                                t_email = existing_contacts_snapshot.value["email"] as! String
                                t_contactsArray.append(User(uid: uid, email: t_email))
                                self.contactsArray = t_contactsArray
                                self.allContactsTable.reloadData()
                            })
                        }
                    }
                }
            }
        })
    }
    
    
    func removeThisUser(sender: UIButton){
        let thisUsersUID = contactsArray[sender.tag].uid
        //        sender.setTitle("Remove", forState: .Normal)
        //        sender.backgroundColor = UIColor.redColor()
        removeContactFromFirebase(thisUsersUID, indexInTable: sender.tag)
        self.allContactsTable.reloadData()
    }
    
    
    
    func removeContactFromFirebase(uidOfNewContact: String, indexInTable: Int){
        let uid = FirebaseHelper.readUidFromNSUserDefaults()
        let contacts = FirebaseHelper.myRootRef.childByAppendingPath("contacts").childByAppendingPath(uid)
        let old_contact = [uidOfNewContact: "false"]
        contacts.updateChildValues(old_contact)
        //        usersArray.removeAtIndex(indexInTable)
    }
    
}
