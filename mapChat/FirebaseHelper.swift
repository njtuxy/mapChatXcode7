//
//  FirebaseHelper.swift
//  mapChat
//
//  Created by Yan Xia on 11/26/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseHelper {
    static let myRootRef = Firebase(url:"https://qd.firebaseio.com")
    
    static func userAlreadyLoggedIn()-> Bool{
        if myRootRef.authData == nil{
            return false
        }
        else{
            return true
        }
    }
    
    func showError(error: NSError) -> NSError{
        return error
    }

    
    static func loginWithEmail(email: String, password: String){
        myRootRef.authUser(email, password: password) {
            error, authData in
            if error != nil {
                // an error occured while attempting login
            } else {
                // user is logged in, check authData for data

            }
        }
        
    }
    
    static func logOut(){
        myRootRef.unauth()
    }
    
    static func saveAuthDataIntoNSUserDefaults(authData: FAuthData){
        //Save authData with NSUserDefaults
        let email = authData.providerData["email"]
        let uid = authData.uid
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(email, forKey: "firebase_email")
        defaults.setObject(uid, forKey: "firebase_uid")
    }
    
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
    
    static func readUidFromNSUserDefaults() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.objectForKey("firebase_uid")
        return uid as! String
    }
    
    static func saveUserInfoInFirebase(uid: String, email: String){
        let user = myRootRef.childByAppendingPath("users").childByAppendingPath(uid)
        let user_info = ["email": email]
        user.updateChildValues(user_info)
    }        
    
}
