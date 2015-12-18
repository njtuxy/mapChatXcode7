//
//  Contact.swift
//  mapChat
//
//  Created by Yan Xia on 12/7/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import Foundation
import Firebase
import Bond
import MapKit


struct Contact {
    
    let email: String!
    let uid: String!
    var selected: Bool!
    
    init(uid: String, email: String, selected: Bool){
        self.email = email
        self.uid = uid
        self.selected = selected
    }
    
}

struct Contacts {
    static var contacts = [Contact]()
}


struct FirebaseRefernces{
    static var sideMenuRef1:Firebase!
    static var sideMenuRef2:Firebase!
}

struct SideMenuContact{
    let email: String!
    let uid: String!
    var selected: Bool!
    
    init(uid: String, email: String, selected: Bool){
        self.uid = uid
        self.email = email
        self.selected = selected
    }
}

struct SideMenuContacts{
    static var contacts = [SideMenuContact]()
}


class Annotation : NSObject, MKAnnotation{
    var uid: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(uid: String, coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        self.uid = uid
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

struct Annotations{
    static var annotations =  [Annotation]()
    static var annotationsDict = [String: Annotation]()
}


struct testBond {
    static var captain = Observable("Jim")
}

struct Status {
    static var contactsLoaded = Observable(false)
    static var loggedInStatus = Observable(false)
    static var annotationUpdated = Observable(false)
}

struct LoginStatus{
    static var loggedin = false
}

struct LocationObserver {
    var ref: Firebase!
    var handle: FirebaseHandle!
    
    init(uid:String){
        ref = FirebaseHelper.myRootRef.childByAppendingPath("locations").childByAppendingPath(uid)
        handle = ref.observeEventType(.Value, withBlock: { SnapShot in
            print("listening to user" + uid)
        })
    }
}

struct LocationObservers {
//    static var observers = [LocationObserver]()
    static var observersDict = [String: LocationObserver]()
}

