//
//  MessageViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/30/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController{
    
    var ref: Firebase!
    var handle: FirebaseHandle!
    
    @IBOutlet weak var lat: UILabel!
    
    @IBOutlet weak var lng: UILabel!
    
    
    @IBAction func stopListening(sender: AnyObject) {
        ref.removeObserverWithHandle(handle)
    }
    
    @IBAction func startListening(sender: AnyObject) {
        monitorUserLocaiton("simplelogin:1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lat.text = "i am lat"
        lng.text = "i am lng"
//        monitorUserLocaiton("simplelogin:1")        
    }
    
    
    
    
    func monitorUserLocaiton(itsUID: String){
        
        ref = FirebaseHelper.myRootRef.childByAppendingPath("locations").childByAppendingPath(itsUID)
        
        handle = ref.observeEventType(.Value, withBlock: { SnapShot in
            print("New value got!")
            print(SnapShot.value["l"])
        })
    }
}
