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
        FirebaseHelper.loginWithEmail(username, password: password)
        updateLoginStatus()
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
