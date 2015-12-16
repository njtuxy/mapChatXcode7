//
//  LeftSideContactsMenuController.swift
//  mapChat
//
//  Created by Yan Xia on 12/8/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift


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
        cell.userLabel.textColor = UIColor.whiteColor()
        
        cell.userIcon.font = UIFont.fontAwesomeOfSize(10)
        cell.userIcon.textColor = UIColor.orangeColor()

//        cell.backgroundColor = UIColor.clearColor()
        
        //Set cell background color based on the contact's select status
        
        let current_status = Contacts.contacts[indexPath.row].selected
        
        print(current_status)
        
        if(current_status == true){
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.Circle)
//            cell.backgroundColor = UIColor.greenColor()
            
        }else{
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleThin)
            cell.backgroundColor = UIColor.clearColor()
        }
        
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("click here")
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LeftSideMenuContactsCell
        
        let current_status = Contacts.contacts[indexPath.row].selected

        setContactSelectedStatus(Contacts.contacts[indexPath.row].uid, status: !current_status, localIndex: indexPath.row)
        
        let new_status = Contacts.contacts[indexPath.row].selected
        
        print(new_status)
        
        if new_status == false{
            print("updated 1")
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleThin)
        }else{
            print("updated 2")
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.Circle)
        }
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.leftSideMenuTable.reloadData()
        print("side Menu loadded")
    }
    
    override func viewDidLoad() {
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sideMenu-background.jpg")!)
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
