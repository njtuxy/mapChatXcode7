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
    
     var myContactsRef:Firebase!
     var myContactsHandle: UInt!
    
    var singleContactRef: Firebase!
    var singleContactHandle: UInt!
    
     var contactsArray = [Contact]()

    
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
        myContactsRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(Me.account.uid).childByAppendingPath("contacts")
        self.downloadContacts()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.myContactsRef.removeObserverWithHandle(self.myContactsHandle)
        self.singleContactRef.removeObserverWithHandle(self.singleContactHandle)
    }
}

//Firebase DataSource:
extension ContacsViewController{
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func downloadContacts(){
            print("download contacts method get called!")
        //---------------------------------------------------------------------------------------------------------------------------------------------
        myContactsHandle = self.myContactsRef.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            print("my contacts ref called")
            if my_contacts_snapshot.exists(){
                for item in my_contacts_snapshot.children{
                    let t_item = item as! FDataSnapshot
                    let uidOfThisContact = t_item.key
                    let selectedStatusOfThisContact = t_item.value as! Bool
                    self.singleContactRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(uidOfThisContact)
                    self.singleContactHandle = self.singleContactRef.observeEventType(.Value, withBlock: { thisContactSnapShot in
                                    print("single contact ref called")
                        var t_contactsArray = [Contact]()
                        let email = thisContactSnapShot.value["email"] as! String
                        let name = thisContactSnapShot.value["name"] as! String
                        let uid = thisContactSnapShot.value["uid"] as! String
                        let base64String = thisContactSnapShot.value["profilePhoto"] as! String
                        let image:UIImage!
                        if base64String.isEmpty {
                            image = UIImage(named: "empty")
                        }else{
                            let imageData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            image = UIImage(data: imageData!)
                        }
                        t_contactsArray.append(Contact(uid: uid, email: email, name: name, profilePhtoto: image, selected: selectedStatusOfThisContact))
                        self.contactsArray = t_contactsArray
                        print(self.contactsArray)
                        self.allContactsTable.reloadData()
                    })
                    //Remove the observer immeidately after get the data. PUT here or on level up? Need to DEBUG.
//                    self.singleContactRef.removeObserverWithHandle(self.singleContactHandle)
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
        let users = FirebaseHelper.rootRef.childByAppendingPath("users")
        let myUid = Me.account.uid
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

