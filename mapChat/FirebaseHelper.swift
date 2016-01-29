//
//  FirebaseHelper.swift
//  mapChat
//
//  Created by Yan Xia on 11/26/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import Foundation
import Firebase
import GeoFire

struct FirebaseHelper {
    static let rootURL = "https://qd.firebaseio.com"
    static let usersURL = "https://qd.firebaseio.com/users"
    static let rootRef = Firebase(url:"https://qd.firebaseio.com")
    static let uid = rootRef.authData.uid    
    static let geoLocation = rootRef.childByAppendingPath("locations")
    static let geoFire = GeoFire(firebaseRef: geoLocation)
    static let myAccountRef = rootRef.childByAppendingPath("users").childByAppendingPath(rootRef.authData.uid)
//    static let myNameRef = rootRef.childByAppendingPath("users").childByAppendingPath(Me.account.uid).childByAppendingPath("name")
//    static let myProfilePhotoRef = rootRef.childByAppendingPath("useres").childByAppendingPath(Me.account.uid).childByAppendingPath("profilePhoto")
    
    func showError(error: NSError) -> NSError{
        return error
    }
    
    static func loginWithEmail(email: String, password: String){
        rootRef.authUser(email, password: password) {
            error, authData in
            if error != nil {
                // an error occured while attempting login
            } else {
                // user is logged in, check authData for data

            }
        }
        
    }
    
    static func logOut(){
        rootRef.unauth()
    }
    
    static func saveAuthDataIntoNSUserDefaults(authData: FAuthData){
        //Save authData with NSUserDefaults
        let email = authData.providerData["email"]
        let uid = authData.uid
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(email, forKey: "firebase_email")
        defaults.setObject(uid, forKey: "firebase_uid")
    }
    
//    static func saveConctactsArrayIntoNSUserDefaults(contacts: [Contact]){
//        let defaults = NSUserDefaults.standardUserDefaults()
//        var array: [Contact] = [Contact]()
//        array = contacts
//        var array1: [NSString] = [NSString]()
//        array1.append("value 1")
//        defaults.setObject(array, forKey: "contacts_array")
//        print(contacts.count)
//    }
    
    
//    static func saveContactsIntoNSUserContacts(contact
    
    static func removeAuthDataFromNSUserDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("firebase_email")
        defaults.removeObjectForKey("firebase_uid")
    }
    
    static func readLoginEmailFromNSUserDefaults() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        let email = defaults.objectForKey("firebase_email")
        return email as! String
    }
    
//    static func readUidFromNSUserDefaults() -> String{
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let uid = defaults.objectForKey("firebase_uid")
//        return uid as! String
//    }
    
    static func saveUserInfoInFirebase(uid: String, email: String, name:String){
        let user = rootRef.childByAppendingPath("users").childByAppendingPath(uid)
        let user_info = ["email": email, "uid": uid, "name": name]
        user.updateChildValues(user_info)
        
    }
    
//    static func getAllUsersFromFirebase(){
//        let users = myRootRef.childByAppendingPath("users")
//        users.queryOrderedByChild("email").observeEventType(.ChildAdded, withBlock: { snapshot in
//            if let email = snapshot.value["email"] as? String {
//                user_email_list.append(email)
//            }
//        })
//    }
    
    static func addContactsObserver(){
        //Load all the contacts and send a singal to the observers to get the latest contacts list
        let myUid = Me.account.uid
        let users = FirebaseHelper.rootRef.childByAppendingPath("users")
        let myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")
        
        myContacts.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            print("contacts loadded now")
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
                        t_contactsArray.append(Contact(uid: uidOfThisContact , email: t_email, selected: selectedStatusOfThisContact))
                        Contacts.contacts = t_contactsArray
                        Status.contactsLoaded.next(true)
                    })
                }
            }
                
            else{
                Contacts.contacts = []
                Status.contactsLoaded.next(true)
            }
        })

    }
    
    
    static func addLocationFirbaseObserverFor(uid:String){

        var ref: Firebase!
        var handle: FirebaseHandle!
        
        ref = FirebaseHelper.rootRef.childByAppendingPath("locations").childByAppendingPath(uid)
        
        handle = ref.observeEventType(.Value, withBlock: { SnapShot in
            
        })

    }
    
}
