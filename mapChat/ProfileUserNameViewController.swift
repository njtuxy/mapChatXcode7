//
//  ProfileUserNameViewController.swift
//  mapChat
//
//  Created by Yan Xia on 2/3/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import UIKit
import Firebase

class ProfileUserNameViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        self.userName.text = Me.account.name
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.userName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(textField: UITextField) {
        if userName.text == Me.account.name{
                self.navigationItem.rightBarButtonItem?.enabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    @IBAction func saveUserName(sender: AnyObject) {
        let userNameRef = Firebase(url: FirebaseHelper.rootURL).childByAppendingPath("users").childByAppendingPath(Me.account.uid).childByAppendingPath("name")
        userNameRef.setValue(userName.text)
        Me.account.name = userName.text!
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
