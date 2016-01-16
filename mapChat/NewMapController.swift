//
//  newMapController.swift
//  mapChat
//
//  Created by Yan Xia on 1/15/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class NewMapController: UIViewController, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var nmapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let location = CLLocationCoordinate2D(
            latitude: 53.4265107,
            longitude: 14.5520357)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        nmapView.setRegion(region, animated: true)
        nmapView.showsPointsOfInterest = false
        nmapView.showsUserLocation = true
        displayMarkers()
    }
    
    // When user taps on the disclosure button you can perform a segue to navigate to another view controller
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            print(view.annotation!.title) // annotation's title
            print(view.annotation!.subtitle) // annotation's subttitle
            
            //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
        }
    }
    
    // Here we add disclosure button inside annotation window
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        var button = UIButton(type: UIButtonType.DetailDisclosure) as UIButton // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    
    
    func displayMarkers() -> Void
    {
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        ann.title = "Park here"
        ann.subtitle = "Fun awaits down the road!"
        nmapView.addAnnotation(ann)
    }
    
}
