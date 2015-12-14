//
//  SecondViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/19/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Firebase
import GeoFire
import Bond

extension UIColor{
    final func toString() -> String{
        var red = 0.0 as CGFloat
        var green = 0.0 as CGFloat
        var blue = 0.0 as CGFloat
        var alpha = 0.0 as CGFloat
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return "\(Int(red))\(Int(green))\(Int(blue))\(Int(alpha))"
    }
}

//Annotation Struct
class Annotation : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

struct Annotations{
    static var annotations =  [Annotation]()
}



class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBAction func addNewLocation(sender: AnyObject) {
                        
        let color = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
        let location = CLLocationCoordinate2D(latitude: 37.782736, longitude:-122.400984)
        
        //Add observer to contacts list,  if checked status is true, then find its current location and add it to Annotations array
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let myContacts = FirebaseHelper.myRootRef.childByAppendingPath("users").childByAppendingPath(myUid).childByAppendingPath("contacts")

        myContacts.observeEventType(.ChildChanged, withBlock: { my_contacts_snapshot in
            if let contacts_uid = my_contacts_snapshot.key{
                FirebaseHelper.geoFire.getLocationForKey(contacts_uid, withCallback: { (location, error) in
                    if(location != nil){
                        let t_location = CLLocationCoordinate2D(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude)
                        Annotations.annotations.append(Annotation(coordinate: t_location, title: String(contacts_uid), subtitle: "this is the user"))
                    }
                    self.mapView.removeAnnotations(Annotations.annotations)
                    self.mapView.addAnnotations(Annotations.annotations)
                    
                })
            }
        })
        
        
        
//        Annotations.annotations.append(Annotation(coordinate: location, title: "A little Park", subtitle: "What ever that is here"))
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    let color = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
    let location = CLLocationCoordinate2D(latitude: 37.782736, longitude:-122.400983)
    
    //Create an annotation array:
    lazy var annotations: [MKAnnotation] = {
//        return [Annotation(coordinate: self.location, title: "A little Park", subtitle: "What ever that is here")]
        return []
    }()
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)        
    }
    

    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        //Setting the map view delegate
        mapView.delegate = self        
        if self.revealViewController() != nil{
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //Here is all the magic happens:
    //IMPORTANT: need to se canShowCallout = true, the default is hidden!
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        
        let view: MKAnnotationView
        let reusedId = "myPin"
        
        if let v = mapView.dequeueReusableAnnotationViewWithIdentifier(reusedId){
            view = v
        }else{
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
        }
        
        //view.pinTintColor = color
        
        view.canShowCallout = true
        
        if let detailImage = UIImage(named: "red"){
            view.detailCalloutAccessoryView = UIImageView(image: detailImage)
        }
        
        if let extIcon = UIImage(named: "super"){
            view.image = extIcon
        }else{
            print("didn't find the image")
        }
        
        
        return view
    }
    
    
    @IBAction func showUser() {
        let currentLocation = mapView.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(currentLocation, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.mapType = .Standard
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = currentLocation
//        annotation.title = "I AM HERE"
//        mapView.addAnnotation(annotation)

        //mapView.camera = MKMapCamera(lookingAtCenterCoordinate: currentLocation, fromDistance: distance, pitch: 0, heading: 0)
//        let mapCamera = MKMapCamera()
//        mapCamera.centerCoordinate  = currentLocation
//        mapCamera.pitch = 45
//        mapCamera.altitude = 500
//        mapCamera.heading = 45
//        
//        self.mapView.camera = mapCamera
        

    }
    
    @IBAction func showLocations() {
            
    }

    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidAppear(animated)
//        print("map view is diappering!!")
//        FirebaseRefernces.sideMenuRef1.removeAllObservers()
//        FirebaseRefernces.sideMenuRef2.removeAllObservers()
//    }
    
}

//extension MapViewController: MKMapViewDelegate { }
