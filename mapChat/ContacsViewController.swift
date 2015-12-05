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
        cell.btnRemoveContact.tag = index
        cell.btnRemoveContact.addTarget(self, action: "removeThisContact:", forControlEvents: .TouchUpInside)
        return cell
        
    }
    
    
    override func viewDidLoad() {
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")
        
        
        //
        myContacts.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            var t_contactsArray = [Contact]()
            var t_email = String()
            print("a got called")
            if my_contacts_snapshot.exists(){
                print("b got called")
                for item in my_contacts_snapshot.children{
                    if let uidOfThisContact = item.key! {
                        let pathOfThisContact = users.childByAppendingPath(uidOfThisContact).childByAppendingPath("email")
                        pathOfThisContact.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                            t_email = thisContactSnapShot.value as! String
                            t_contactsArray.append(Contact(uid: uidOfThisContact , email: t_email))
                            self.contactsArray = t_contactsArray
                            self.allContactsTable.reloadData()
                        })
                    }
                }
            }else{
                print("c got called")
                self.contactsArray = []
                self.allContactsTable.reloadData()
            }
        })
    }
    
    
    func removeThisContact(sender: UIButton){
        let thisContactUID = contactsArray[sender.tag].uid
        //        sender.setTitle("Remove", forState: .Normal)
        //        sender.backgroundColor = UIColor.redColor()
        removeContact(thisContactUID, indexInTable: sender.tag)
//        self.allContactsTable.reloadData()
    }
//
//    
//    
    func removeContact(thisContactUID: String, indexInTable: Int){
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        
        
        //Remove from my contact list
        let thisContact = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(thisContactUID)
        
        thisContact.removeValue()
        
        //Also from me this users's contact
        let me = users.childByAppendingPath(thisContactUID).childByAppendingPath("contacts").childByAppendingPath(myUid)
        me.removeValue()
        
    }
    
}
