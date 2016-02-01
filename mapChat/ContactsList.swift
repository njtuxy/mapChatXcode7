////
////  ContactsList.swift
////  mapChat
////
////  Created by Yan Xia on 2/1/16.
////  Copyright © 2016 yxia. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//struct ContactsList{
//    var contactsArray:[Contact]!
//    init(){
//        print("in the contact list init method!")
//        let ref = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(FirebaseHelper.rootRef.authData.uid).childByAppendingPath("contacts")
//        print(ref)
//        ref.observeSingleEventOfType(.Value, withBlock: { my_contacts_snapshot in
//            print("contacts handle get called!")
//            self.contactsArray = []
//            if my_contacts_snapshot.exists() {
//                print("called in the struct!")
//                self.loadContacts(my_contacts_snapshot)
//            }else{
//                print("nothing found!")
//            }
//        })
//    }
//    
//    mutating func loadContacts(contacts: FDataSnapshot){
//        for contact in contacts.children{
//            let item = contact as! FDataSnapshot
//            let uid = item.key
//            let status = item.value as! Bool
//            let singleContactRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(uid)
//            singleContactRef.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
//                let email = thisContactSnapShot.value["email"] as! String
//                let name = thisContactSnapShot.value["name"] as! String
//                let uid = thisContactSnapShot.value["uid"] as! String
//                let base64String = thisContactSnapShot.value["profilePhoto"] as! String
//                let profilePhoto = FirebaseHelper.readUserImage(base64String)
//                self.contactsArray.append(Contact(uid: uid, email: email, name: name, profilePhtoto: profilePhoto, selected: status))
//                print(name)
////                self.allContactsTable.reloadData()
//            })
//        }
//    }
//}
//
//class sharedMethods {
//    var contactsArray:[Contact]!
//    
//    class func yourFunc(talbeview: UITableView) {
//        let ref = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(FirebaseHelper.rootRef.authData.uid).childByAppendingPath("contacts")
//        ref.observeSingleEventOfType(.Value, withBlock: { my_contacts_snapshot in
//            if my_contacts_snapshot.exists() {
//                self.loadContacts123(my_contacts_snapshot, tableView: talbeview)
//            }else{
//                print("nothing found!")
//            }
//        })
//    }
//    
//    class func loadContacts123(contacts: FDataSnapshot, tableView: UITableView){
//        for contact in contacts.children{
//            let item = contact as! FDataSnapshot
//            let uid = item.key
//            let status = item.value as! Bool
//            var contactsArray:[Contact] = []
//            let singleContactRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(uid)
//            singleContactRef.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
//                let email = thisContactSnapShot.value["email"] as! String
//                let name = thisContactSnapShot.value["name"] as! String
//                let uid = thisContactSnapShot.value["uid"] as! String
//                let base64String = thisContactSnapShot.value["profilePhoto"] as! String
//                let profilePhoto = FirebaseHelper.readUserImage(base64String)
//                print(name)
//                contactsArray.append(Contact(uid: uid, email: email, name: name, profilePhtoto: profilePhoto, selected: status))
//                tableView.reloadData()
//            })
//        }
//    }
//
//}