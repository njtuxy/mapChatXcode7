//
//  Contact.swift
//  mapChat
//
//  Created by Yan Xia on 12/7/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import Foundation
import Firebase

struct Contact {
    
    let email: String!
    let uid: String!
    
    init(uid: String, email: String){
        self.email = email
        self.uid = uid
    }
}

struct Contacts {
    static var contacts = [Contact]()
}

struct FirebaseRefernces{
    static var sideMenuRef1:Firebase!
    static var sideMenuRef2:Firebase!
}