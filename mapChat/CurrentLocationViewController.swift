//
//  FirstViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/19/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit

import CoreLocation



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
    
    @IBOutlet weak var tagButton: UIButton!

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
            showTopMessage("Searching...")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            print("We havebeen here")
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
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longtitudeLabel.text = String(format: "%8f", location.coordinate.longitude)
            tagButton.hidden = false
            messageLabel.text = ""
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
    
        
}


