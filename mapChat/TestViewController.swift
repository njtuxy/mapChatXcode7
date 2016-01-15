//
//  TestViewController.swift
//  mapChat
//
//  Created by Yan Xia on 1/13/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import Foundation
import Persei
import MapKit
import Firebase

class TestViewController: UITableViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    private weak var menu: MenuView!
    
    var subTitleShown:Bool = false
    var subTitleLabel:UILabel!

    var ref:Firebase!
    var myContacts: Firebase!

    var handle: UInt!
    var locationHandle: UInt!
    
    var contacts = [MenuItem]()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let image2 = UIImage(named: "menu_icon_0")
        myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")

        
        handle = myContacts.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            print("contacts loadded now")
            var t_contactsArray = [MenuItem]()
            var t_email = String()
            
            if my_contacts_snapshot.exists(){
                for item in my_contacts_snapshot.children{
                    let t_item = item as! FDataSnapshot
                    let uidOfThisContact = t_item.key
                    let selectedStatusOfThisContact = t_item.value as! Bool
                    let pathOfThisContact = users.childByAppendingPath(uidOfThisContact).childByAppendingPath("email")
                    pathOfThisContact.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                        t_email = thisContactSnapShot.value as! String
                        t_contactsArray.append(MenuItem(image: image2!, email: t_email, uid: uidOfThisContact))
                        self.contacts = t_contactsArray
                        self.refreshMenuItems()
                    })
                }
            }
                
            else{
                self.contacts = []
            }
        })
        
    }
    
    func refreshMenuItems(){
        menu.items = self.contacts
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        ref.removeObserverWithHandle(handle)
        ref.removeObserverWithHandle(locationHandle)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMenu()
        //Init firebase ref:
        ref = Firebase(url:"https://qd.firebaseio.com")
        
        //Configure the navigation bar:
        let navBar = self.navigationController?.navigationBar
        navBar!.barStyle = UIBarStyle.Black
        navBar!.barTintColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
        navBar!.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "HelveticaNeue-Light", size: 20)!]
        
        //Thess 4 lines of code are for changeing the border color:
        //let navBorder: UIView = UIView(frame: CGRectMake(0, navBar!.frame.size.height - 1, navBar!.frame.size.width, 1))
        //navBorder.backgroundColor = UIColor.whiteColor()
        //navBorder.opaque = true
        //navBar!.addSubview(navBorder)
        
        //This 2 lines of code are for hidding the navigation bar border:
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
//        //Show login view if user hasn't loggedin:
//        if(!FirebaseHelper.userAlreadyLoggedIn()){
//            let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = myStoryBoard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
//            self.presentViewController(vc, animated: true, completion: nil)
//        }else{
//            FirebaseHelper.addContactsObserver()
//        }
        
        
//        print(Annotations.annotationsDict)
        //Load top contacts menu
     
    }
    
    private func loadMenu() {
        print("Loadding the menu")
        let menu = MenuView()
        menu.backgroundColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
        tableView.addSubview(menu)
        menu.delegate = self
        self.menu = menu
    }
    
    // MARK: - Actions
    @IBAction
    private func switchMenu() {
        menu.setRevealed(!menu.revealed, animated: true)
    }
    


    func addObservers(uidOfContact:String, email: String){
        if(LocationObservers.observersDict[uidOfContact] == nil){
            LocationObservers.observersDict[uidOfContact] = LocationObserver(uid: uidOfContact, email: email)
        }
    }
    
    func removeObservers(uidOfContact:String){
        print("removeing firebase ob for this user: " + uidOfContact)
        
        if(LocationObservers.observersDict[uidOfContact] != nil){
            LocationObservers.observersDict[uidOfContact]?.ref.removeObserverWithHandle((LocationObservers.observersDict[uidOfContact]?.handle)!)
            LocationObservers.observersDict[uidOfContact] = nil
            
            //Also need to remove th e annotations from Annotations array and send the observer event
            Annotations.annotationsDict.removeValueForKey(uidOfContact)
            Status.annotationUpdated.next(true)
        }
    }

    
    func centerMapToCoordinate(coordinate: CLLocationCoordinate2D, mapView: MKMapView){
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.mapType = .Standard
    }
    
    func addContactToMapAndCenterMapToIt(uidOfContact:String, email: String, lat: Double, lng: Double){
        
        let t_location = CLLocationCoordinate2D(latitude:lat, longitude:lng)
        
        Annotations.annotationsDict[uidOfContact] = Annotation(uid: uidOfContact, coordinate: t_location, title: email, subtitle: "this is the user")
        
        let annotations = Array(Annotations.annotationsDict.values)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotations(annotations)
        
        centerMapToCoordinate(t_location, mapView: self.mapView)
        
    }
    
}


// MARK: - MenuViewDelegate
extension TestViewController: MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) {
//        model = model.next()
        

        let uid = contacts[index].uid
        let email = contacts[index].email

        
        
        let location = ref.childByAppendingPath("locations").childByAppendingPath(uid)
        
        locationHandle = location.observeEventType(.Value, withBlock: { SnapShot in
            
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
                                lat = t_item1.value as! Double
                        }
                        
                        if(t_item1.key == "1"){
                                lng = t_item1.value as! Double
                        }
                        
                    }
                    
                    let t_location = CLLocationCoordinate2D(latitude:lat, longitude:lng)
                    self.addContactToMapAndCenterMapToIt(uid, email: email, lat: lat, lng: lng)
                }
            }
        })
    }
}







/*
func hideSubTitle(){
subTitleLabel.removeFromSuperview()
subTitleLabel = nil
}

func showSubtitle(){
let navBar = self.navigationController?.navigationBar
let firstFrame = CGRect(x: navBar!.frame.width/3, y: 25, width: navBar!.frame.width/2, height: navBar!.frame.height)
subTitleLabel = UILabel(frame: firstFrame)
subTitleLabel.text = "Choose a contact:"
subTitleLabel.textColor = UIColor.whiteColor()
subTitleLabel.textAlignment = NSTextAlignment.Left
subTitleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 12)
navBar!.addSubview(subTitleLabel)
}

//    func hideSubtitle(){
//        let navBar = self.navigationController?.navigationBar
//        let firstFrame = CGRect(x: navBar!.frame.width/3, y: 0, width: navBar!.frame.width/2, height: navBar!.frame.height)
//        subTitleLabel = UILabel(frame: firstFrame)
//        let firstLabel = UILabel(frame: firstFrame)
//        subTitleLabel.textColor = UIColor.whiteColor()
//        subTitleLabel.textAlignment = NSTextAlignment.Left
//        subTitleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 12)
//        navBar!.addSubview(subTitleLabel)
//    }

// MARK: - Items
//    private let items = (0..<7 as Range).map {_ in
//        MenuItem(image: UIImage(named: "contacts")!)
//    }

// MARK: - Items
//    private let items = (0..<7 as Range).map {_ in
//        MenuItem(image: UIImage(named: "contacts")!)
//    }

//    private var model: ContentType = ContentType.Films {
//        didSet {
//            title = model.description
//            if isViewLoaded() {
//                let center: CGPoint = {
//                    let itemFrame = self.menu.frameOfItemAtIndex(self.menu.selectedIndex!)
//                    let itemCenter = CGPoint(x: itemFrame.midX, y: itemFrame.midY)
//
//                    let convertedCenter1 = mapView.convertPoint(CGPointMake(0, 0), toCoordinateFromView: self.view)
//                    let convertCenter = mapView.convertCoordinate(convertedCenter1, toPointToView: self.view)
//
//                    print(convertCenter)
//
//                    return convertCenter
//                }()
//
//
//
//                //                let transition = CircularRevealTransition(layer: imageView.layer, center: center)
//                //                transition.start()
//                //
//                //                imageView.image = model.image
//            }
//        }
//    }

*/


