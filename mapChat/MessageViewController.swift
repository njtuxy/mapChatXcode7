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
    
    @IBOutlet weak var txtMessage: UITextField!
    
    @IBAction func sendMessage(sender: UIButton) {
        
        let message = txtMessage.text!
        
        if message == ""{
            showNoticeTextWithDelay("Message is empty!", delay: 1)
            return
        }
        
        let uid = FirebaseHelper.readUidFromNSUserDefaults()
        
        print(uid)
        
        let userInfo = FirebaseHelper.myRootRef.childByAppendingPath("usersInfo").childByAppendingPath(uid)
        
        print(userInfo)
        
        var users = ["alanisawesome": "xyz", "gracehop": "11100"]
        
        userInfo.setValue(users)
        
    }
    

    
    //Notice popup helper:
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func showNoticeTextWithDelay(text:String, delay:Double){
        self.noticeOnlyText(text)
        self.delay(delay){
            self.clearAllNotice()
        }
    }
    
//    func saveAuthDataIntoNSUserDefaults(authData: FAuthData){
//        //Save authData with NSUserDefaults
//        let email = authData.providerData["email"]
//        let uid = authData.uid
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(email, forKey: "firebase_email")
//        defaults.setObject(uid, forKey: "firebase_uid")
//    }
//    
//    func removeAuthDataFromNSUserDefaults(){
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.removeObjectForKey("firebase_email")
//        defaults.removeObjectForKey("firebase_uid")
//    }
//    
//    func readLoginEmailFromNSUserDefaults() -> String{
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let email = defaults.objectForKey("firebase_email")
//        return email as! String
//    }
//    
//    func readUidFromNSUserDefaults() -> String{
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let uid = defaults.objectForKey("firebase_uid")
//        return uid as! String
//    }
    
    
    
    
}
