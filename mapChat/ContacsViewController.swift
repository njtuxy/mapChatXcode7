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
    
     var myContacts:Firebase!
     var contactsArray = [Contact]()
     var handle: UInt!
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //Make a transparent navigation bar:
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.downloadContacts()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseHelper.myRootRef.removeObserverWithHandle(handle)
    }
}

//Firebase DataSource:
extension ContacsViewController{
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func downloadContacts(){
        let myUid = Me.authData.uid
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")
        //---------------------------------------------------------------------------------------------------------------------------------------------
        handle = myContacts.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            var t_contactsArray = [Contact]()
            var t_email = String()
            if my_contacts_snapshot.exists(){
                for item in my_contacts_snapshot.children{
                    let t_item = item as! FDataSnapshot
                    let uidOfThisContact = t_item.key
                    let selectedStatusOfThisContact = t_item.value as! Bool
                    let pathOfThisContact = users.childByAppendingPath(uidOfThisContact).childByAppendingPath("email")
                    pathOfThisContact.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                        t_email = thisContactSnapShot.value as! String
                        t_contactsArray.append(Contact(uid: uidOfThisContact, email: t_email, selected: selectedStatusOfThisContact))
                        self.contactsArray = t_contactsArray
                        self.allContactsTable.reloadData()
                    })
                }
            }
            else{
                self.contactsArray = []
                self.allContactsTable.reloadData()
            }
        })
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func removeThisContact(sender: UIButton){
        let thisContactUID = self.contactsArray[sender.tag].uid
        removeContact(thisContactUID, indexInTable: sender.tag)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func removeContact(thisContactUID: String, indexInTable: Int){
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let myUid = Me.authData.uid
        //Firebase - Remove from my contact list
        let thisContact = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(thisContactUID)
        thisContact.removeValue()
        //Firebase - Also from me this users's contact
        let me = users.childByAppendingPath(thisContactUID).childByAppendingPath("contacts").childByAppendingPath(myUid)
        me.removeValue()
    }
}

//Table opererations:
//---------------------------------------------------------------------------------------------------------------------------------------------
extension ContacsViewController{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsCell", forIndexPath: indexPath) as! ContactsViewCell
        cell.selectionStyle = .None
        
        let index = indexPath.row
        // Configure the cell...
        cell.txtUserEmail.text = self.contactsArray[index].email
        cell.txtUserEmail.textColor = UIColor.whiteColor()
        cell.btnRemoveContact.tag = index
        cell.btnRemoveContact.addTarget(self, action: "removeThisContact:", forControlEvents: .TouchUpInside)
        cell.btnRemoveContact.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.btnRemoveContact.setTitle(String.fontAwesomeIconWithName(.MinusCircle), forState: .Normal)
        cell.btnRemoveContact.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        return cell
    }
}


//        //Add contacts observer
//        Status.contactsLoaded.observeNew{ value in
//            self.allContactsTable.reloadData()
//        }
//        sender.setTitle("Remove", forState: .Normal)
//        sender.backgroundColor = UIColor.redColor()
//        self.allContactsTable.reloadData()

