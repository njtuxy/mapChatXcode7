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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsername.delegate = self
        txtPassword.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        
        
        FirebaseHelper.rootRef.authUser(username, password:password){
                error, authData in
                if error != nil {
                    self.showNoticeTextWithDelay(error.localizedDescription, delay: 2)

                } else {
                    self.showNoticeTextWithDelay("Logged in succesfully!", delay: 1)

                    //Show root view
                    let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = myStoryBoard.instantiateViewControllerWithIdentifier("tabsView")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                    //Save authData to local
                    
                    let email = authData.providerData["email"] as! String
                    let uid = authData.uid
                    let name = "SignUpUBaba"
                    Me.account  = Account( uid:uid, email: email, name:name)
            }
        }                 
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
    
    @IBAction func dosomething(sender: AnyObject) {
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = myStoryBoard.instantiateViewControllerWithIdentifier("signUpWindow")
        self.presentViewController(vc, animated: true, completion: nil)

    }
}
