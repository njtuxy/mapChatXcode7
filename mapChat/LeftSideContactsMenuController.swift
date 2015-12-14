//
//  LeftSideContactsMenuController.swift
//  mapChat
//
//  Created by Yan Xia on 12/8/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase


class LeftSideContactsMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var leftSideMenuTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contacts.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftSideMenuCell", forIndexPath: indexPath) as! LeftSideMenuContactsCell
        cell.selectionStyle = .None
        
        let index = indexPath.row

        // Configure the cell...
        
        
        cell.userLabel.text = Contacts.contacts[index].email
        
        print("-------------------")
        print("setting cell background color")
        print("-------------------")
        
        
        
        //Set cell background color based on the contact's select status
        
        let current_status = Contacts.contacts[indexPath.row].selected
        
        if(current_status == true){
            cell.backgroundColor = UIColor.greenColor()
        }else{
            cell.backgroundColor = .None
        }

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let current_status = Contacts.contacts[indexPath.row].selected
        
        setContactSelectedStatus(Contacts.contacts[indexPath.row].uid, status: !current_status)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("side menu is going hide")
    }
    
    override func viewDidLoad() {
        
        //Set a observer to the contacts list, once the contacts list get loaddd, reload the tableView.

        Status.contactsLoaded.observeNew{ value in
            print("contacts loadded, going to refresh the sideMenu table view")
            self.leftSideMenuTable.reloadData()
        }

        
/*
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")
        
        
        //
        myContacts.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            var t_contactsArray = [SideMenuContact]()
            var t_email = String()
            if my_contacts_snapshot.exists(){
                for item in my_contacts_snapshot.children{
                    if let uidOfThisContact = item.key! {
                        let pathOfThisContact = users.childByAppendingPath(uidOfThisContact).childByAppendingPath("email")
                        pathOfThisContact.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                            t_email = thisContactSnapShot.value as! String
                            t_contactsArray.append(SideMenuContact(uid: uidOfThisContact , email: t_email, selected: false))
                            SideMenuContacts.contacts = t_contactsArray
//                            Contacts.contacts = t_contactsArray
                            self.leftSideMenuTable.reloadData()
                        })
                    }
                }
            }
                
            else{
                Contacts.contacts = []
                self.leftSideMenuTable.reloadData()
            }
        })
*/
    }
    
    
    func setContactSelectedStatus(uidOfContact: String, status: Bool){
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        
        //Save the stranger's UID to current user's node
        
        let contactListOfCurrentUser = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(uidOfContact)
        
        contactListOfCurrentUser.setValue(status)        
        
        //Save current user's UID to stranger's node.
        let contactListOfStanger = users.childByAppendingPath(uidOfContact).childByAppendingPath("contacts").childByAppendingPath(myUid)
        contactListOfStanger.setValue(status)
    }

    
    
}
