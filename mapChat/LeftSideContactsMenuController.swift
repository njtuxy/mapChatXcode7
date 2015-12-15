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

        print("log 1")
        print(Contacts.contacts[indexPath.row])
        
        setContactSelectedStatus(Contacts.contacts[indexPath.row].uid, status: !current_status, localIndex: indexPath.row)
        
        print("log 2")
        print(Contacts.contacts[indexPath.row])
        
        let new_status = Contacts.contacts[indexPath.row].selected
        
        if new_status == false{
           cell?.backgroundColor = .None
        }else{
            cell?.backgroundColor = UIColor.greenColor()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(Contacts.contacts)
        self.leftSideMenuTable.reloadData()

    }
    
    override func viewDidLoad() {
        
        //Set a observer to the contacts list, once the contacts list get loaddd, reload the tableView.

        //--Todo: Don't refresh table view every time when change the contacts
        
        Status.contactsLoaded.observeNew{ value in

        }

    }
    
    
    func setContactSelectedStatus(uidOfContact: String, status: Bool, localIndex: Int){
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        
        //Save the stranger's UID to current user's node
        let contactListOfCurrentUser = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(uidOfContact)
        contactListOfCurrentUser.setValue(status)        
        
        //Save current user's UID to stranger's node.
        let contactListOfStanger = users.childByAppendingPath(uidOfContact).childByAppendingPath("contacts").childByAppendingPath(myUid)
        contactListOfStanger.setValue(status)
        
        //Also update locat Contacts value:
        Contacts.contacts[localIndex].selected = status
    }

    
    
}
