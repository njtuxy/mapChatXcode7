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
        
        Status.annotationUpdated.observeNew{ value in
            let annotations = Array(Annotations.annotationsDict.values)
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            self.mapView.addAnnotations(annotations)
        }
        
    }
    
    override func viewDidLoad() {
        
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
        
        
        //Setting the map view delegate
        mapView.delegate = self
        if self.revealViewController() != nil{
            sideMenuButton.target = self.revealViewController()
            self.revealViewController().rearViewRevealWidth = 200
            sideMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
}

//extension MapViewController: MKMapViewDelegate { }
