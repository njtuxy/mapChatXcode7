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
    
    struct Contact {

        let email: String!
        let uid: String!
        
        init(uid: String, email: String){
            self.email = email
            self.uid = uid
        }
    }
    
    
    var contactsArray = [Contact]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsCell", forIndexPath: indexPath) as! ContactsViewCell
        
        let index = indexPath.row
        // Configure the cell...
        cell.txtUserEmail.text = self.contactsArray[index].email
        //        cell.btnRemoveContact.tag = index
        //        cell.btnRemoveContact.addTarget(self, action: "removeThisUser:", forControlEvents: .TouchUpInside)
        return cell
        
    }
    
    
    override func viewDidLoad() {
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")
        
        var t_contactsArray = [Contact]()
        var t_email = String()
        myContacts.observeSingleEventOfType(.Value, withBlock: { my_contacts_snapshot in
            if my_contacts_snapshot.exists(){
                for item in my_contacts_snapshot.children{
                    if let uidOfThisContact = item.key {
                        let pathOfThisContact = users.childByAppendingPath(uidOfThisContact).childByAppendingPath("email")
                        pathOfThisContact.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                            t_email = thisContactSnapShot.value as! String
                            t_contactsArray.append(Contact(uid: String(uidOfThisContact), email: t_email))
                            self.contactsArray = t_contactsArray
                            self.allContactsTable.reloadData()
                        })
                    }
                    
                }
            }
        })
    }
    
    
//    func removeThisUser(sender: UIButton){
//        let thisUsersUID = contactsArray[sender.tag].uid
//        //        sender.setTitle("Remove", forState: .Normal)
//        //        sender.backgroundColor = UIColor.redColor()
//        removeContactFromFirebase(thisUsersUID, indexInTable: sender.tag)
//        self.allContactsTable.reloadData()
//    }
//    
//    
//    
//    func removeContactFromFirebase(uidOfNewContact: String, indexInTable: Int){
//        let uid = FirebaseHelper.readUidFromNSUserDefaults()
//        let contacts = FirebaseHelper.myRootRef.childByAppendingPath("contacts").childByAppendingPath(uid)
//        let old_contact = [uidOfNewContact: "false"]
//        contacts.updateChildValues(old_contact)
//        //        usersArray.removeAtIndex(indexInTable)
//    }
    
}
