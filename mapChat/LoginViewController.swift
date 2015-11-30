//
//  LoginViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/27/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    
    @IBOutlet weak var currentLoginStatus: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func logOut(sender: AnyObject) {
        FirebaseHelper.logOut()
        showNoticeTextWithDelay("You have logged out!", delay: 2)
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
                }
            }
        
        
        
        

        
        
//        FirebaseHelper.loginWithEmail(username, password: password)
//        while(!FirebaseHelper.userAlreadyLoggedIn()){
//            self.pleaseWait()
//        }
//        updateLoginStatus()
    }
    
    
    func disableLoginItems(){
        self.txtUsername.borderStyle = UITextBorderStyle.None
        self.txtPassword.borderStyle = UITextBorderStyle.None
        self.txtUsername.enabled = false
        self.txtPassword.enabled = false
        self.loginButton.enabled = false 
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
        updateLoginStatus()


//        showCurrentLoggedInStatus(FirebaseHelper.userAlreadyLoggedIn())
        
//        showCurrentLoggedInStatus(true)
        
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    

}
