//
//  SignUpViewController.swift
//  mapChat
//
//  Created by Yan Xia on 1/22/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var txtUserEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtPasswordConfirmation: UITextField!
    
    @IBOutlet weak var txtUserName: UITextField!

    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirmation.delegate = self
        txtUserName.delegate = self
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @IBAction func signUp(sender: UIButton) {
        let email = txtUserEmail.text
        let password = txtPassword.text
        let passwordConfirmation = txtPasswordConfirmation.text
        let name = txtUserName.text
        
        if(email == ""){
            self.showNoticeTextWithDelay("user email is empty", delay: 1)
            return
        }
        
        if(password == ""){
            self.showNoticeTextWithDelay("password is empty", delay: 1)
            return
        }
        
        if(passwordConfirmation == ""){
            self.showNoticeTextWithDelay("please confirm your password", delay: 1)
            return
        }
        
        if(password != passwordConfirmation){
            self.showNoticeTextWithDelay("password and confirmation don't match!", delay: 1)
            return
        }
        
        if(name == ""){
            self.showNoticeTextWithDelay("name is empty", delay: 1)
            return
        }
        
        self.signUp()
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func signUp(){
        let email = txtUserEmail.text
        let password = txtPassword.text
        FirebaseHelper.rootRef.createUser(email, password: password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    if(error.code == -9){
                        self.showNoticeTextWithDelay("The specified email address is already in use.", delay: 1)
                        return
                    } else{
                        self.showNoticeTextWithDelay("Unkonwn error.", delay: 1)
                        return
                    }
                    
                } else {
                    let message = "Successfully created user account!"
                    self.showNoticeTextWithDelay(message, delay: 1)
                    self.login()
                }
        })
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func saveUserAccountInfoInFirebase(uid:String){
        FirebaseHelper.rootRef.childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("name").setValue(txtUserName.text)
        FirebaseHelper.rootRef.childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("uid").setValue(uid)
        FirebaseHelper.rootRef.childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("email").setValue(txtUserEmail.text)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func login(){
        FirebaseHelper.rootRef .authUser(txtUserEmail.text, password: txtPassword.text,
            withCompletionBlock: { error, authData in
                if error != nil {
                } else {
                    self.showRootView()
                    self.saveUserAccountInfoInFirebase(authData.uid)
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func showRootView(){
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = myStoryBoard.instantiateViewControllerWithIdentifier("tabsView")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @IBAction func closeWindow(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func showNoticeTextWithDelay(text:String, delay:Double){
        self.noticeOnlyText(text)
        self.delay(delay){
            self.clearAllNotice()
        }
    }

    
}
