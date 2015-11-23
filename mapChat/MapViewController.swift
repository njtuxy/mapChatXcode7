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

class MapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!

    var managedObjectContext: NSManagedObjectContext!
    
//    let distance: CLLocationDistance = 700
//    let pitch: CGFloat = 65

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
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("Running the code here")
        
        let view: MKPinAnnotationView
        
        if let v = mapView.dequeueReusableAnnotationViewWithIdentifier(color.toString()){
            view = v as! MKPinAnnotationView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: color.toString())
        }
        
        view.pinTintColor = color
        
        view.canShowCallout = true
        
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
}

//extension MapViewController: MKMapViewDelegate { }
