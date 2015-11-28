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
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func logOut(sender: AnyObject) {
        FirebaseHelper.logOut()
        updateLoginStatus()
    }
    
    @IBAction func logIn(sender: UIButton) {
        let username = txtUsername.text!
        let password = txtPassword.text!
        
        if(username == ""){
            self.noticeOnlyText("username is empty!")
            delay(1){
                self.clearAllNotice()
            }
            return
        }

        if(password == ""){
            self.noticeOnlyText("password is empty!")
            delay(1){
                self.clearAllNotice()
            }
            return
        }

        
        
//        FirebaseHelper.loginWithEmail(username, password: password)
//        while(!FirebaseHelper.userAlreadyLoggedIn()){
//            self.pleaseWait()
//        }
//        updateLoginStatus()
    }
    
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
        
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
        }else{
            currentLoginStatus.text = "not logged in"
        }
        
    }

}
