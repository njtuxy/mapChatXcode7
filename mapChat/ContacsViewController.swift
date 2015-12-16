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
    

    
    var contactsArray = [Contact]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contacts.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsCell", forIndexPath: indexPath) as! ContactsViewCell
        cell.selectionStyle = .None
        
        let index = indexPath.row
        // Configure the cell...
        cell.txtUserEmail.text = Contacts.contacts[index].email
        cell.txtUserEmail.textColor = UIColor.whiteColor()
        cell.btnRemoveContact.tag = index
        cell.btnRemoveContact.addTarget(self, action: "removeThisContact:", forControlEvents: .TouchUpInside)
        cell.btnRemoveContact.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.btnRemoveContact.setTitle(String.fontAwesomeIconWithName(.MinusCircle), forState: .Normal)
        cell.btnRemoveContact.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        return cell
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.allContactsTable.reloadData()

//
//        if(LoginStatus.loggedin == false){
//            self.navigationItem.rightBarButtonItem = nil
//        }
        
    }
    
    override func viewDidLoad() {
        
        //Make a transparent navigation bar:        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true

        
        //Add contacts observer
        Status.contactsLoaded.observeNew{ value in
            print("contacts loadded, going to refresh the sideMenu table view")
            self.allContactsTable.reloadData()
        }

        
        
    }
    
    func removeThisContact(sender: UIButton){
        let thisContactUID = Contacts.contacts[sender.tag].uid
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
        
        
        //Firebase - Remove from my contact list
        let thisContact = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(thisContactUID)
        
        thisContact.removeValue()
        
        //Firebase - Also from me this users's contact
        let me = users.childByAppendingPath(thisContactUID).childByAppendingPath("contacts").childByAppendingPath(myUid)
        me.removeValue()        
    }
    
}
