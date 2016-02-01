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
    
     var conatctViewContactsRef:Firebase!
     var myContactsHandle: UInt!
    
     var singleContactRef: Firebase!
     var singleContactHandle: UInt!
    
     var contactsArray = [Contact]()
     var contactsUidArray = [String]()

    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //Make a transparent navigation bar:
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.conatctViewContactsRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(Me.account.uid).childByAppendingPath("contacts")
        self.downloadMyContacts()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//Firebase DataSource:
extension ContacsViewController{
    
    func loadContacts(contacts: FDataSnapshot){
        for contact in contacts.children{
            let item = contact as! FDataSnapshot
            let uid = item.key
            let status = item.value as! Bool
            let singleContactRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(uid)
            singleContactRef.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                let email = thisContactSnapShot.value["email"] as! String
                let name = thisContactSnapShot.value["name"] as! String
                let uid = thisContactSnapShot.value["uid"] as! String
                let base64String = thisContactSnapShot.value["profilePhoto"] as! String
                let profilePhoto = FirebaseHelper.readUserImage(base64String)
                self.contactsArray.append(Contact(uid: uid, email: email, name: name, profilePhtoto: profilePhoto, selected: status))
                self.allContactsTable.reloadData()
            })
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func downloadMyContacts(){
        conatctViewContactsRef.observeSingleEventOfType(.Value, withBlock: { my_contacts_snapshot in
            print("contacts handle get called!")
            self.contactsArray = []
            if my_contacts_snapshot.exists() {
                self.loadContacts(my_contacts_snapshot)
            }else{
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
        let users = FirebaseHelper.rootRef.childByAppendingPath("users")
        let myUid = Me.account.uid
        //Firebase - Remove from my contact list
        let thisContact = users.childByAppendingPath(myUid).childByAppendingPath("contacts").childByAppendingPath(thisContactUID)
        thisContact.removeValue()
        //Firebase - Also from me this users's contact
        let me = users.childByAppendingPath(thisContactUID).childByAppendingPath("contacts").childByAppendingPath(myUid)
        me.removeValue()
        downloadMyContacts()
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
        cell.txtUserEmail.text = self.contactsArray[index].name
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

