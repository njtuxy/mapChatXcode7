//
//  ProfileViewController.swift
//  mapChat
//
//  Created by Yan Xia on 1/28/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController:UIViewController{
    
    @IBAction func closeWindow(sender: AnyObject) {
        print("close the window")
            self.dismissViewControllerAnimated(true, completion: nil)
    }
}
