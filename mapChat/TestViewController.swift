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
    var mapViewContactsRef: Firebase!
    var myAccountRef: Firebase!
    var myContactsLocationRef: Firebase!
    
    var contactsHandle: UInt!
    var locationHandle: UInt!
    var accountHandle: UInt!
    var contacts = [MenuItem]()

    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMenu()
        configNavigationBar()
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myAccountRef = Firebase(url: FirebaseHelper.usersURL).childByAppendingPath(FirebaseHelper.uid)
        mapViewContactsRef = Firebase(url: FirebaseHelper.usersURL).childByAppendingPath(FirebaseHelper.uid).childByAppendingPath("contacts")
        readUserAccountInfo()
        downloadMyContacts()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
//        myContactsRef.removeObserverWithHandle(contactsHandle)
//        myAccountRef.removeObserverWithHandle(accountHandle)
//        if let lh = locationHandle {
//            myContactsRef.removeObserverWithHandle(lh)
//        }
        //ref.removeObserverWithHandle(locationHandle)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func readUserAccountInfo(){
        accountHandle = myAccountRef.observeEventType(.Value, withBlock: { (snapShot) in
            let email = snapShot.value["email"] as! String
            let name = snapShot.value["name"] as! String
            let uid = snapShot.value["uid"] as! String
            let base64String = snapShot.value["profilePhoto"] as! String
            let image:UIImage!
            if base64String.isEmpty {
                image = UIImage(named: "empty")
            }else{
                let imageData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                image = UIImage(data: imageData!)
            }
            Me.account  = Account( uid:uid, email: email, name:name, profilePhoto: image)
            self.removeeAccountObserver()
        })
    }
    
    func removeeAccountObserver(){
        myAccountRef.removeObserverWithHandle(accountHandle)
    }
}

//Map Operations:
extension TestViewController{
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func centerMapToCoordinate(coordinate: CLLocationCoordinate2D, mapView: MKMapView){
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.mapType = .Standard
    }
}

//UI Configurations:
extension TestViewController{
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Actions
    @IBAction
    private func switchMenu() {
        menu.setRevealed(!menu.revealed, animated: true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func showSubtitle(){
        let navBar = self.navigationController?.navigationBar
        let firstFrame = CGRect(x: navBar!.frame.width/3, y: 25, width: navBar!.frame.width/2, height: navBar!.frame.height/2)
        subTitleLabel = UILabel(frame: firstFrame)
        subTitleLabel.text = "You can add a contact from contacts tab"
        subTitleLabel.textColor = UIColor.whiteColor()
        subTitleLabel.textAlignment = NSTextAlignment.Left
        subTitleLabel.font = UIFont (name: "HelveticaNeue-Light", size: 12)
        navBar!.addSubview(subTitleLabel)
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func configNavigationBar(){
        let navBar = self.navigationController?.navigationBar
        navBar!.barStyle = UIBarStyle.Black
        navBar!.tintColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
        navBar!.barTintColor = UIColor(red: 72.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
        navBar!.translucent = false
        title = "4 contacts online"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont (name: "HelveticaNeue-Light", size: 20)!]
        //This 2 lines of code are for hidding the navigation bar border:
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func loadMenu() {
        let menu = MenuView()
//        menu.backgroundColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
        menu.backgroundColor = UIColor(red: 72.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
        
        tableView.addSubview(menu)
        menu.delegate = self
        self.menu = menu
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func refreshMenuItems(){
        menu.items = self.contacts
    }
    


}

//Firebase DataSource:
extension TestViewController {
    func loadContacts(contacts: FDataSnapshot){
        for contact in contacts.children{
            let item = contact as! FDataSnapshot
            let uid = item.key
            let singleContactRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(uid)
            singleContactRef.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                let email = thisContactSnapShot.value["email"] as! String
                let name = thisContactSnapShot.value["name"] as! String
                let uid = thisContactSnapShot.value["uid"] as! String
                let base64String = thisContactSnapShot.value["profilePhoto"] as! String
                let profilePhoto = FirebaseHelper.readUserImage(base64String)
                self.contacts.append(MenuItem(image: profilePhoto, email: email, uid: uid, name: name))
                self.refreshMenuItems()
            })
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func downloadMyContacts(){
        mapViewContactsRef.observeSingleEventOfType(.Value, withBlock: { my_contacts_snapshot in
            self.contacts = []
            if my_contacts_snapshot.exists() {
                self.loadContacts(my_contacts_snapshot)
            }else{
                self.refreshMenuItems()
            }
        })
    }

}

//---------------------------------------------------------------------------------------------------------------------------------------------
extension TestViewController: MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) {
        let uid = contacts[index].uid
        let email = contacts[index].email
        let name = contacts[index].name
        let image = contacts[index].image
        
        myContactsLocationRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("locations").childByAppendingPath(uid)
        
        locationHandle = myContactsLocationRef.observeEventType(.Value, withBlock: { SnapShot in
//            print("listening to user" + uid)
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
                    //let t_location = CLLocationCoordinate2D(latitude:lat, longitude:lng)
                    self.addContactToMapAndCenterMapToIt(uid, email: email, name: name, lat: lat, lng: lng, image:image)
                }
            }
        })
    }
    
}

//Map Annotations functions
//---------------------------------------------------------------------------------------------------------------------------------------------
extension TestViewController: MKMapViewDelegate {

        //Open chat window if user click on the annotation popup callout accessory:
        //---------------------------------------------------------------------------------------------------------------------------------------------
        func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView{
                ChatWindow.contact = (view.annotation as! Annotation).title
                ChatWindow.contactEmail = (view.annotation as! Annotation).email
                performSegueWithIdentifier("showChatWindow", sender: self)
            }
        }

        //Configure the annotation callout UI
        //---------------------------------------------------------------------------------------------------------------------------------------------
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

                if annotation is MKUserLocation {
                    return nil
                }
            var v: MKAnnotationView! = nil
            if  annotation is Annotation{
                let newAnnotation = annotation as! Annotation
                let reuseId = "pin"
                v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
                if v == nil {
                    v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                    print(annotation.title)
                    v.image = newAnnotation.image?.circle2
                    v.canShowCallout = true
                    
                    v.bounds.size.height /= 10.0
                    v.bounds.size.width /= 10.0
                    //                    pinView!.animatesDrop = true
                }
                
            }
            
            let button1 = UIButton(type: UIButtonType.System)
            button1.frame = CGRectMake(0, 0, 30, 30)
            button1.setImage(UIImage.fontAwesomeIconWithName(.CommentsO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25)), forState: .Normal)
            v.rightCalloutAccessoryView = button1
            v.annotation = annotation
            return v
        }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func addContactToMapAndCenterMapToIt(uidOfContact:String, email: String, name:String, lat: Double, lng: Double, image:UIImage){
        let t_location = CLLocationCoordinate2D(latitude:lat, longitude:lng)
        Annotations.annotationsDict[uidOfContact] = Annotation(uid: uidOfContact, coordinate: t_location, title: name, subtitle: email, email: email, image:image)
        let annotations = Array(Annotations.annotationsDict.values)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotations(annotations)
        centerMapToCoordinate(t_location, mapView: self.mapView)
    }

}

extension UIImage{
        var circle2: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/20
        imageView.layer.masksToBounds = true
//        imageView.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).CGColor
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 5
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
        }

        var chatAvatar: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/10
        imageView.layer.masksToBounds = true
//        imageView.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).CGColor
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 15
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
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

//        let ann = MKPointAnnotation()
//        ann.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
//        ann.title = "Park here"
//        ann.subtitle = "Fun awaits down the road!"
//        self.mapView.addAnnotation(ann)
//        displayMarkers()

//
//        let london = ContactOnMap(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
//        let oslo = ContactOnMap(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
//        let paris = ContactOnMap(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
//        let rome = ContactOnMap(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
//        let washington = ContactOnMap(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
//



//        func displayMarkers() -> Void
//        {
//            let annotationView = MKAnnotationView()
//            let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
//            annotationView.rightCalloutAccessoryView = detailButton
//
//            let ann = MKPointAnnotation()
//            ann.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
//            ann.title = "Park here"
//            ann.subtitle = "Fun awaits down the road!"
//            self.mapView.addAnnotation(ann)
//        }

//Thess 4 lines of code are for changeing the border color:
//let navBorder: UIView = UIView(frame: CGRectMake(0, navBar!.frame.size.height - 1, navBar!.frame.size.width, 1))
//navBorder.backgroundColor = UIColor.whiteColor()
//navBorder.opaque = true
//navBar!.addSubview(navBorder)

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

// MARK: - Actions
    
//    func addObservers(uidOfContact:String, email: String){
//        if(LocationObservers.observersDict[uidOfContact] == nil){
//            LocationObservers.observersDict[uidOfContact] = LocationObserver(uid: uidOfContact, email: email)
//        }
//    }

//    func removeObservers(uidOfContact:String){
//        print("removeing firebase ob for this user: " + uidOfContact)
//
//        if(LocationObservers.observersDict[uidOfContact] != nil){
//            LocationObservers.observersDict[uidOfContact]?.ref.removeObserverWithHandle((LocationObservers.observersDict[uidOfContact]?.handle)!)
//            LocationObservers.observersDict[uidOfContact] = nil
//
//            //Also need to remove th e annotations from Annotations array and send the observer event
//            Annotations.annotationsDict.removeValueForKey(uidOfContact)
//            Status.annotationUpdated.next(true)
//        }
//    }

