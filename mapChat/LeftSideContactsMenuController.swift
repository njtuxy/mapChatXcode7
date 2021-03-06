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
    private var selectedLocatorIndex:Int?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contacts.contacts.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftSideMenuCell", forIndexPath: indexPath) as! LeftSideMenuContactsCell
        
        cell.selectionStyle = .None
        
        let index = indexPath.row

        cell.userLabel.text = Contacts.contacts[index].email
        cell.userLabel.textColor = UIColor.whiteColor()
        
        //Must set userInteractionEnabled to true so the gestures can work
        cell.userLabel.userInteractionEnabled = true

        //Add Gestures to the UILabel
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: "centerMapOnThisContact:")
        cell.userLabel.addGestureRecognizer(doubleTap)
        
        cell.userIcon.font = UIFont.fontAwesomeOfSize(10)
        cell.userIcon.textColor = UIColor.orangeColor()        
        
        //Set cell background color based on the contact's select status
        
        let current_status = Contacts.contacts[indexPath.row].selected
        
        print(Contacts.contacts)
        
        if(current_status == true){
//            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.Circle)
//            enableCellLocatorButton(cell, index : index)
            addObservers(Contacts.contacts[indexPath.row].uid, email: Contacts.contacts[indexPath.row].email)
            
        }else{
//            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleThin)

            //cell.backgroundColor = UIColor.clearColor()
//            disableCellLocatorButton(cell)
//            removeObservers(Contacts.contacts[indexPath.row].uid)
        }
        
        return cell
        
    }
    
    
    func centerMapOnThisContact(sender: UITapGestureRecognizer){
        
        //Get the indexPath based on the tap locaiton:
        let tapLocation = sender.locationInView(self.leftSideMenuTable)
        let indexPath : NSIndexPath = self.leftSideMenuTable.indexPathForRowAtPoint(tapLocation)!
        let index = indexPath.row
        let thisContactUID = Contacts.contacts[index].uid

        let current_status = Contacts.contacts[indexPath.row].selected
        setContactSelectedStatus(Contacts.contacts[indexPath.row].uid, status: !current_status, localIndex: indexPath.row)
        
        print(Contacts.contacts[index])
        
        //        sender.setTitle("Remove", forState: .Normal)
        //        sender.setTitleColor(UIColor.greenColor(), forState: .Normal)
        //        print(Annotations.annotationsDict[thisContactUID]?.coordinate)
        
        print(Annotations.annotationsDict)
//        CurrentLocatedContact.location = (Annotations.annotationsDict[thisContactUID]?.coordinate)!
//        Status.locateContact.next(true)

//        print(CurrentLocatedContact.location)

    }

    
    func enableCellLocatorButton(cell: LeftSideMenuContactsCell, index: Int){
        cell.locator.tag = index
        cell.locator.addTarget(self, action: "showThisContactOnMap", forControlEvents: .TouchUpInside)
        cell.locator.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.locator.setTitle(String.fontAwesomeIconWithName(.Eye), forState: .Normal)
        
        //Set the locator radio button color
        
        if let tselectedLocatorIndex = selectedLocatorIndex {
            if tselectedLocatorIndex == index{
                cell.locator.setTitleColor(UIColor.greenColor(), forState: .Normal)
            }
            else{
                cell.locator.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            }
        }
        else{
            cell.locator.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        }

        

    }
    
    func disableCellLocatorButton(cell: LeftSideMenuContactsCell){
        cell.locator.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.locator.removeTarget(self, action: "locateThisContact:", forControlEvents: .TouchUpInside)
        cell.locator.setTitle(String.fontAwesomeIconWithName(.Eye), forState: .Normal)
        cell.locator.setTitleColor(UIColor.grayColor(), forState: .Normal)
    }
    
    
    func locateThisContact(sender: UIButton){
        //set this value for the locator radio button
        selectedLocatorIndex = sender.tag
        
//        print(sender.tag)
        let thisContactUID = Contacts.contacts[sender.tag].uid
//        sender.setTitle("Remove", forState: .Normal)
//        sender.setTitleColor(UIColor.greenColor(), forState: .Normal)
//        print(Annotations.annotationsDict[thisContactUID]?.coordinate)
        CurrentLocatedContact.location = (Annotations.annotationsDict[thisContactUID]?.coordinate)!
        Status.locateContact.next(true)
        
        print(CurrentLocatedContact.location)
        
        self.leftSideMenuTable.reloadData()
        
        //sender.backgroundColor = UIColor.greenColor()
    }
        
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LeftSideMenuContactsCell
//        
//        let current_status = Contacts.contacts[indexPath.row].selected
//
//        setContactSelectedStatus(Contacts.contacts[indexPath.row].uid, status: !current_status, localIndex: indexPath.row)
//        
//        let new_status = Contacts.contacts[indexPath.row].selected
//        
//        if new_status == false{
//            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleThin)
//            disableCellLocatorButton(cell)
//
//            //Reset the selectedLocatorIndex, so when the cell got selected again, it won't carry on the button heighted color
//            resetSelectedLocatorIndex(indexPath.row)
//            
//        }else
//        {
//            enableCellLocatorButton(cell, index:indexPath.row)
//            cell.userIcon.text = String.fontAwesomeIconWithName(FontAwesome.Circle)
//        }
//        
//        
//    }

    func resetSelectedLocatorIndex(index:Int) {
        if let tselectedLocatorIndex = selectedLocatorIndex {
            if tselectedLocatorIndex == index{
                selectedLocatorIndex = nil
            }
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
        
        let myUid = Me.account.uid
        
        let users = FirebaseHelper.rootRef.childByAppendingPath("users")
        
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
            LocationObservers.observersDict[uidOfContact] = LocationObserver(uid: uidOfContact, email: email)
        }
    }
    
    func removeObservers(uidOfContact:String){
        print("removeing firebase ob for this user: " + uidOfContact)
        
        if(LocationObservers.observersDict[uidOfContact] != nil){
            LocationObservers.observersDict[uidOfContact]?.ref.removeObserverWithHandle((LocationObservers.observersDict[uidOfContact]?.handle)!)
            LocationObservers.observersDict[uidOfContact] = nil
            
            //Also need to remove the annotations from Annotations array and send the observer event
            Annotations.annotationsDict.removeValueForKey(uidOfContact)
            Status.annotationUpdated.next(true)
        }
    }
    
    
    
    
}
