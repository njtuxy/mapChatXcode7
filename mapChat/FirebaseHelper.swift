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
}
