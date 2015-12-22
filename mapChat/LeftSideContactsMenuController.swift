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
import MapKit


class LeftSideContactsMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var leftSideMenuTable: UITableView!
    
    private var tableFirstTimeAppears = true
    
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
        
        //Set cell background color based on the contact's select status
        
        let current_status = Contacts.contacts[indexPath.row].selected
        
        if(current_status == true){
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.Circle)
            addObservers(Contacts.contacts[indexPath.row].uid, email: Contacts.contacts[indexPath.row].email)
            
        }else{
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleThin)
            cell.backgroundColor = UIColor.clearColor()
            removeObservers(Contacts.contacts[indexPath.row].uid)
        }
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LeftSideMenuContactsCell
        
        let current_status = Contacts.contacts[indexPath.row].selected

        setContactSelectedStatus(Contacts.contacts[indexPath.row].uid, status: !current_status, localIndex: indexPath.row)
        
        let new_status = Contacts.contacts[indexPath.row].selected
        
        if new_status == false{
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleThin)
        }else{
            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.Circle)
        }
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if(tableFirstTimeAppears == true){
//            //Do something only for the first time when table view loads
//            tableFirstTimeAppears = false
//        }else{
//            self.leftSideMenuTable.reloadData()
//        }
        
        self.leftSideMenuTable.reloadData()
    }
    
    override func viewDidLoad() {
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sideMenu-background.jpg")!)
    }
    
    
    func setContactSelectedStatus(uidOfContact: String, status: Bool, localIndex: Int){
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        
        //Save status to Firebase:
        
        //Save the stranger's UID to current user's node
        let contactListOfCurrentUser = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(uidOfContact)
        contactListOfCurrentUser.setValue(status)        
        
        //Save current user's UID to stranger's node.
        let contactListOfStanger = users.childByAppendingPath(uidOfContact).childByAppendingPath("contacts").childByAppendingPath(myUid)
        contactListOfStanger.setValue(status)
        
        
        //Update local value:
        
        Contacts.contacts[localIndex].selected = status
        
        //Update the Annotation array
        //If status == false, then remove the value from key
        //If status == true, then add value for the key
        
        if(status == true){
//            removeAnnotation(uidOfContact)
            addObservers(uidOfContact, email:  Contacts.contacts[localIndex].email)
            
        }else{
            
            // Add firebase observer to this contact's location
//            addAnnotations(uidOfContact)
            removeObservers(uidOfContact)
        }
    }


    
    func addObservers(uidOfContact:String, email: String){
        if(LocationObservers.observersDict[uidOfContact] == nil){
            print("Added location observer for " + uidOfContact)
            LocationObservers.observersDict[uidOfContact] = LocationObserver(uid: uidOfContact, email: email)
        }

    }
    
    func removeObservers(uidOfContact:String){
        if(LocationObservers.observersDict[uidOfContact] != nil){
            print("Removed location observer of " + uidOfContact)
            LocationObservers.observersDict[uidOfContact]?.ref.removeObserverWithHandle((LocationObservers.observersDict[uidOfContact]?.handle)!)
            LocationObservers.observersDict[uidOfContact] = nil
            
            //Also need to remove the annotations from Annotations array and send the observer event
            Annotations.annotationsDict.removeValueForKey(uidOfContact)
            Status.annotationUpdated.next(true)
        }
    }
    
    
    
}
