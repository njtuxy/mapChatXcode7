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

struct Account{
    var uid: String
    var email: String
    var name: String
    var profilePhoto: UIImage
}

struct UserInfo {
    let uid: String!
    let email: String!
    let name: String!
    
    init(authData: FAuthData, name:String){
        self.email = authData.providerData["email"] as! String        
        self.uid = authData.uid
        self.name = name
    }
}

struct Me{
    static var account: Account!
}



struct Contact {
    var uid: String!
    var email: String!
    var name: String!
    var profilePhtoto: UIImage!
    var selected: Bool!
    
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

//Customized map annotation class: 
class Annotation : NSObject, MKAnnotation{
    var uid: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var email: String?
    var image: UIImage?
    
    init(uid: String, coordinate: CLLocationCoordinate2D, title: String, subtitle: String, email:String, image:UIImage){
        self.uid = uid
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.email = email
        self.image = image
    }
}

struct Annotations{
    static var annotations =  [Annotation]()
    static var annotationsDict = [String: Annotation]()
}


struct Status {
    static var contactsLoaded = Observable(false)
    static var loggedInStatus = Observable(false)
    static var annotationUpdated = Observable(false)
    static var locateContact = Observable(false)
    static var trackingMyCurrentLocation = Observable(false)
}

struct ChatWindow {
    static var contact:String?
    static var contactEmail:String?
}


struct LoginStatus{
    static var loggedin = false
}

struct CurrentTracking{
    static var dispose: DisposableType?
    
//    static var dispose: DisposableType? {
//        set {
//        
//        }
//        get {
//            return newValue
//        }
//    }
}

struct LocationObserver {
    var ref: Firebase!
    var handle: FirebaseHandle!
    var lat: Double!
    var lng: Double!
    var email: String!
    
    
    init(uid:String, email:String){
        
        self.email = email
        
        print("adding a firebase ob for this user: " + email)
        
        ref = FirebaseHelper.rootRef.childByAppendingPath("locations").childByAppendingPath(uid)
        handle = ref.observeEventType(.Value, withBlock: { SnapShot in

            print("listening to user" + uid)
            
            
            //FIX IT? IT MIGHT NOT A GOOD SOLUTION, THINKING ABOUT SUBSCRIPT
            
            //PERFORMACE ISSUE HERE?
            
            for item in SnapShot.children{
                
                let t_item = item as! FDataSnapshot
                
                if(t_item.key == "l"){

                    var lat: Double!
                    var lng: Double!

                    for item1 in t_item.children{
                        
                        let t_item1 = item1 as! FDataSnapshot
                        
                        if(t_item1.key == "0"){
                            if(LocationObservers.observersDict[uid] != nil){
                                lat = t_item1.value as! Double
//                                LocationObservers.observersDict[uid]?.lat = t_item1.value as! Double
                            }
                        }
                        
                        if(t_item1.key == "1"){
                            if(LocationObservers.observersDict[uid] != nil){
                                lng = t_item1.value as! Double
//                                LocationObservers.observersDict[uid]?.lng = t_item1.value as! Double
                            }
                        }
                    }
                    
//                    addAnnotationFromObserver(uid, email:email, lat: lat, lng: lng)
                    
                }
                
            }
            
        })
    }
}

struct LocationObservers {
    static var observersDict = [String: LocationObserver]()
}

//func addAnnotationFromObserver(uidOfContact:String, email: String, lat: Double, lng: Double){
//    
//    print("adding a local ob for this user: " + email)
//    
//    let t_location = CLLocationCoordinate2D(latitude:lat, longitude:lng)
//    
//    Annotations.annotationsDict[uidOfContact] = Annotation(uid: uidOfContact, coordinate: t_location, title: email, subtitle: "this is the user", email: email)
//    
//    print("Going to update the annotations array - add event")
//    
//    Status.annotationUpdated.next(true)
//}

struct CurrentLocatedContact {
    static var location = CLLocationCoordinate2D()
}

enum ContentType: String, CustomStringConvertible {
    
    case Music = "content_music.png"
    case Films = "content_films.png"
    
    func next() -> ContentType {
        switch self {
        case .Music:
            return .Films
        case .Films:
            return .Music
        }
    }
    
    var image: UIImage {
        let image =  UIImage(named: rawValue)!
        return image
    }
    
    var description: String {
        switch self {
        case .Music:
            return "Music"
        case .Films:
            return "Films"
        }
    }
    
//    var coordindate: CLLocationCoordinate2D {
//        switch self {
//        case .Music:
//            return [1,2]
//        case .Films:
//            return "Films"
//        }
//    }
}

/*
func addAnnotations(uidOfContact:String){
    
    FirebaseHelper.geoFire.getLocationForKey(uidOfContact, withCallback: { (location, error) in

        if(location != nil){
            let t_location = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude)
            
            Annotations.annotations.append(Annotation(uid: uidOfContact, coordinate: t_location, title: String(uidOfContact), subtitle: "this is the user"))
            
            Annotations.annotationsDict[uidOfContact] = Annotation(uid: uidOfContact, coordinate: t_location, title: String(uidOfContact), subtitle: "this is the user")
        }
    })
}

func removeAnnotation(uidOfContact:String){
    print("Going to update the annotations array - remove event")
    Annotations.annotationsDict.removeValueForKey(uidOfContact)
    Status.annotationUpdated.next(false)
}
*/

