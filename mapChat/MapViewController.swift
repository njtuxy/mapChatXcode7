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

class MapViewController: UIViewController, MKMapViewDelegate, ENSideMenuDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    
    let color = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
    let location = CLLocationCoordinate2D(latitude: 37.782736, longitude:-122.400983)
    
    //Create an annotation array:
    lazy var annotations: [MKAnnotation] = {
        return [Annotation(coordinate: self.location, title: "A little Park", subtitle: "What ever that is here")]
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
    
    override func viewDidLoad() {
        //Setting the map view delegate
        mapView.delegate = self
        //Setting the sideMenu delegate
        self.sideMenuController()?.sideMenu?.delegate = self
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

    //SideMenu Bar Button
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

    
    //SideMenu Functions
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    

    
}

//extension MapViewController: MKMapViewDelegate { }
