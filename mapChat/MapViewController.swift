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
import Foundation
import FontAwesome_swift
import Persei


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



class MapViewController: UIViewController, MKMapViewDelegate{
    
    var currentLocationCoordinate: CLLocationCoordinate2D?
    var currentlyTracking = false;
    

    
//    var dispose: DisposableType?
    /*
    var timer: dispatch_source_t!
    
    func startTimer() {
        print("starting the timer!")
        let queue = dispatch_queue_create("com.domain.app.timer", nil)
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 1 * NSEC_PER_SEC) // every 60 seconds, with leeway of 1 second
        dispatch_source_set_event_handler(timer) {
            // do whatever you want here
        }
        dispatch_resume(timer)
    }
    
    func stopTimer() {
        print("Stopping the timer!")
        dispatch_source_cancel(timer)
        timer = nil
    }
    
    //Create an annotation array:
    lazy var annotations: [MKAnnotation] = {
    //        return [Annotation(coordinate: self.location, title: "A little Park", subtitle: "What ever that is here")]
    return []
    }()

    */
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //Reload all annotations:
        Status.annotationUpdated.observeNew{ value in
            let annotations = Array(Annotations.annotationsDict.values)
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            self.mapView.addAnnotations(annotations)
        }
        
        
//        Status.locateContact.observe{ value in
//            print("========== fond a new locate contact request ===========")
//            CurrentTracking.dispose?.dispose()
//            let corr = CurrentLocatedContact.location
//            self.locateThisContact(corr)
//        }
        
    }
    
    override func viewDidLoad() {
        
//        mapView.userTrackingMode = .Follow
        
        super.viewDidLoad()
                
        //Close the sidemenu when touch the map
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
        //Show login view if user hasn't loggedin:
        
        if(!FirebaseHelper.userAlreadyLoggedIn()){
            let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = myStoryBoard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            FirebaseHelper.addContactsObserver()
        }
        
        
        //Setting the map view delegate, with sideMenu width:
        mapView.delegate = self
        if self.revealViewController() != nil{
            sideMenuButton.target = self.revealViewController()
            self.revealViewController().rearViewRevealWidth = 200
            sideMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Set the bar button image:
//        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
//        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, forState: .Normal)
//        self.navigationItem.rightBarButtonItem?.title = String.fontAwesomeIconWithName(.Github)
        
//        var image = UIImage(named: "locate")
        let image = UIImage.fontAwesomeIconWithName(.SquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "locateAndTrack")

    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    

    
    //Here is all the magic happens:
    //IMPORTANT: need to se canShowCallout = true, the default is hidden!
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//
//        
//        let view: MKAnnotationView
//        let reusedId = "myPin"
//        
//        if let v = mapView.dequeueReusableAnnotationViewWithIdentifier(reusedId){
//            view = v
//        }else{
//            view = MKAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
//        }
//        
//        //view.pinTintColor = color
//        
//        view.canShowCallout = true
//        
//        if let detailImage = UIImage(named: "red"){
//            view.detailCalloutAccessoryView = UIImageView(image: detailImage)
//        }
//        
//        if let extIcon = UIImage(named: "super"){
//            view.image = extIcon
//        }else{
//            print("didn't find the image")
//        }
//        
//        
//        return view
//    }
    
//    func locateThisContact(coordinate: CLLocationCoordinate2D){
//        let dis = Status.trackingMyCurrentLocation.observe{ value in
//            print("track the change again")
//            if let currentLocation = self.currentLocationCoordinate{
//                let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
//                self.mapView.mapType = .Standard
//            }
//        }
//    }
    
    
    @IBAction func showUser() {
        let currentLocation = mapView.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(currentLocation, 1000, 1000)
//        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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

//    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        var center = mapView.userLocation.coordinate
//        print("here is the new center:")
//        print(center)
//    }
    
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        self.currentLocationCoordinate = userLocation.coordinate
//        print("update user location")
//        Status.trackingMyCurrentLocation.next(true)
//    }
    
    
    
    func centerMapToCoordinate(coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.mapType = .Standard
    }
    
    
    //This is the bar button on the top right side of the mapView, to locate and track the user's current location:
    func locateAndTrack() {
        
        //use one observer to track the
        
        if !currentlyTracking {
            currentlyTracking = true
            
            let image = UIImage.fontAwesomeIconWithName(.Square, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "locateAndTrack")
            
            //Always center map to current coordinate
            let dis = Status.trackingMyCurrentLocation.observe{ value in
                print("track the change again")
                if let currentLocation = self.currentLocationCoordinate{
                    let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
                    self.mapView.mapType = .Standard
                }
            }
            
            CurrentTracking.dispose = dis
            
        }
        else{
            currentlyTracking = false
        
            CurrentTracking.dispose?.dispose()
            
            let image = UIImage.fontAwesomeIconWithName(.SquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "locateAndTrack")
            
        }
        
        


    }
}

//extension MapViewController: MKMapViewDelegate { }
