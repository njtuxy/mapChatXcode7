//
//  LoginViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/27/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var currentLoginStatus: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func logOut(sender: AnyObject) {
        FirebaseHelper.logOut()
        showNoticeTextWithDelay("You have logged out!", delay: 2)
        self.removeAuthDataFromNSUserDefaults()
        enableLoginItems()
        updateLoginStatus()
    }
    
    @IBAction func logIn(sender: UIButton) {
        let username = txtUsername.text!
        let password = txtPassword.text!
        
        if(username == ""){
            self.showNoticeTextWithDelay("username is empty", delay: 1)
            return
        }

        if(password == ""){
            self.showNoticeTextWithDelay("password is empty", delay: 1)
            
            return
        }
        
        //Authenticate with firebase
        FirebaseHelper.myRootRef.authUser(username, password:password){
                error, authData in
                if error != nil {
                    self.showNoticeTextWithDelay(error.localizedDescription, delay: 2)

                } else {
                    // user is logged in, check authData for data
                    self.showNoticeTextWithDelay("Logged in succesfully!", delay: 1)
                    self.updateLoginStatus()
                    
                    //Save authData with NSUserDefaults
                    self.saveAuthDataIntoNSUserDefaults(authData)
            }
        }
    }
    
    
    func disableLoginItems(){
        self.txtUsername.borderStyle = UITextBorderStyle.None
        self.txtPassword.borderStyle = UITextBorderStyle.None
        self.txtUsername.enabled = false
        self.txtPassword.enabled = false
        self.loginButton.enabled = false
        
        //if the current textBox is empty, and there is auth data, fill int he textFile user authData
        if self.txtUsername.text == "" {
            self.txtUsername.text = readLoginEmailFromNSUserDefaults()
        }
        
            
    }

    func enableLoginItems(){
        self.txtUsername.borderStyle = UITextBorderStyle.RoundedRect
        self.txtPassword.borderStyle = UITextBorderStyle.RoundedRect
        self.txtUsername.enabled = true
        self.txtPassword.enabled = true
        self.loginButton.enabled = true
    }
        
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsername.delegate = self
        txtPassword.delegate = self
        
        updateLoginStatus()


//        showCurrentLoggedInStatus(FirebaseHelper.userAlreadyLoggedIn())
        
//        showCurrentLoggedInStatus(true)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtPassword) {
            textField.resignFirstResponder()
            // call the login logic
//            login();
            
        } else if (textField == self.txtUsername) {
            textField.resignFirstResponder()
//            self.passwordText.becomeFirstResponder();
        }
        
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLoginStatus() {

        if FirebaseHelper.userAlreadyLoggedIn(){
            currentLoginStatus.text = "already logged in"
            disableLoginItems()
        }else{
            currentLoginStatus.text = "not logged in"
        }
    }
    
    func saveAuthDataIntoNSUserDefaults(authData: FAuthData){
        //Save authData with NSUserDefaults
        let email = authData.providerData["email"]
        let uid = authData.uid
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(email, forKey: "firebase_email")
        defaults.setObject(uid, forKey: "firebase_uid")
    }
    
    func removeAuthDataFromNSUserDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("firebase_email")
        defaults.removeObjectForKey("firebase_uid")
    }
    
    func readLoginEmailFromNSUserDefaults() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        let email = defaults.objectForKey("firebase_email")
        return email as! String
    }

    func readUidFromNSUserDefaults() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.objectForKey("firebase_uid")
        return uid as! String
    }


}
