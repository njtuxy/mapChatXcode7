//
//  FirstViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/19/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GeoFire



class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {

    //Doc: Store a strong reference to an instance of CLLocationManager
    //CLLocationManager is included in CoreLocation framework
    let locationManager = CLLocationManager()
    
    let locationServiceDisableMsg = "Location Service Is Disabled!"
    
//    var location: CLLocation?
    
    var updatingLocation = false
    
//    var lastLocationError: NSError?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longtitudeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func getLocation(sender: AnyObject) {
    

        //First check the auth status
        let authStatus = CLLocationManager.authorizationStatus()
        
        //If auth denies or is restricted, show an alert to ask user to go to settings
        if authStatus == CLAuthorizationStatus.Denied || authStatus == .Restricted{
            showLocationServicesDeniedAlert()
            return
        }
        
        //If not authed yet, display an alert window for use to select yes or no
        if authStatus == CLAuthorizationStatus.NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        //put location manager to work
        startLocationManager()
    }
    
    @IBAction func stopSharing(sender: UIButton) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showTopMessage("Tap 'Get My Location' to Start")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Mark: 
    //Steps:
    //Step1: Set the delegate to current class which already conformed to CLLocationManagerDelegate
    //Step2: Call the class method (not delegation methods) to start update the location
    //Step3: Call delegation function to do thing accorodingly.
    
    func startLocationManager(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            showLocationServicesDeniedAlert()
        }
    }

    //Feels like a listener
    // print("didUpdateLocations \(newLocation)")
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
//         print("didUpdateLocations \(location)")
        updateLocationLabels(location)
    }


    //MARK: Location manager methods:
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.LocationUnknown.rawValue{
            return
        }
        stopLocationManager()
        showErrorMessage(error)
    }

    
    func stopLocationManager(){
        if updatingLocation{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }

    }

    
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Diabled", message: "Please enable location service for this app in Settings", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLocationLabels(location:CLLocation){
        let myUid = Me.authData.uid
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longtitudeLabel.text = String(format: "%8f", location.coordinate.longitude)
        //Save location to Firebase
        
        saveCurrentLocationToFirebase(location.coordinate.latitude, lng: location.coordinate.longitude, forKey: myUid)
            messageLabel.text = ""
    }
    
    func saveCurrentLocationToFirebase(lat: Double, lng: Double, forKey: String){
        FirebaseHelper.geoFire.setLocation(CLLocation(latitude: lat, longitude: lng), forKey: forKey)
    }
    
    
    
    
    func showErrorMessage(error:NSError){
        let statusMessage: String
        if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue{
            statusMessage = "Location Service Disabled"
        } else{
            statusMessage = "Error Getting Location"
        }
        showTopMessage(statusMessage)
    }
    
    func showTopMessage(message: String){
        messageLabel.text = message
    }
    
    @IBAction func queryOthers(sender: UIButton) {
        FirebaseHelper.addLocationFirbaseObserverFor("simplelogin:1")
        
    }
    
    func findOthers(){
        
        print("start to query!")
        
        let center = CLLocation(latitude: 37.782278, longitude: -122.400629)
        let circleQuery = FirebaseHelper.geoFire.queryAtLocation(center, withRadius: 24)
        
        let queryHandle = circleQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            print("Key '\(key)' entered the search area and is at location '\(location)'")
        })
    }
    
    
    
        
}


