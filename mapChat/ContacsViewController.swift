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
        configNavigationBar()
        
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
                let profilePhoto = FirebaseHelper.readUserImage(base64String).circle2
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
        cell.profilePhoto.image = self.contactsArray[index].profilePhtoto
//        cell.txtUserEmail.textColor = UIColor.whiteColor()
        cell.btnRemoveContact.tag = index
        cell.btnRemoveContact.addTarget(self, action: "removeThisContact:", forControlEvents: .TouchUpInside)
        cell.btnRemoveContact.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.btnRemoveContact.setTitle(String.fontAwesomeIconWithName(.MinusCircle), forState: .Normal)
        cell.btnRemoveContact.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        return cell
    }
}

extension ContacsViewController{
    func configNavigationBar(){
        let navBar = self.navigationController?.navigationBar
        navBar!.barStyle = UIBarStyle.Black
        navBar!.tintColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
        navBar!.barTintColor = UIColor(red: 72.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
        navBar!.translucent = false
        title = "My Contacts"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "HelveticaNeue-Light", size: 20)!]
        //This 2 lines of code are for hidding the navigation bar border:
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
}

//        //Add contacts observer
//        Status.contactsLoaded.observeNew{ value in
//            self.allContactsTable.reloadData()
//        }
//        sender.setTitle("Remove", forState: .Normal)
//        sender.backgroundColor = UIColor.redColor()
//        self.allContactsTable.reloadData()

