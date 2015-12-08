//
//  SideMenuTableViewController.swift
//  mapChat
//
//  Created by Yan Xia on 11/24/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit
import Firebase

class SideMenuTableViewController: UITableViewController {

    var selectedMenuItem : Int = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let myUid = FirebaseHelper.readUidFromNSUserDefaults()
        let users = FirebaseHelper.myRootRef.childByAppendingPath("users")
        let myContacts = users.childByAppendingPath(myUid).childByAppendingPath("contacts")
        myContacts.observeEventType(.Value, withBlock: { my_contacts_snapshot in
            var t_contactsArray = [Contact]()
            var t_email = String()
            if my_contacts_snapshot.exists(){
                for item in my_contacts_snapshot.children{
                    if let uidOfThisContact = item.key! {
                        let pathOfThisContact = users.childByAppendingPath(uidOfThisContact).childByAppendingPath("email")
                        pathOfThisContact.observeSingleEventOfType(.Value, withBlock: { thisContactSnapShot in
                            t_email = thisContactSnapShot.value as! String
                            t_contactsArray.append(Contact(uid: uidOfThisContact , email: t_email))
                            Contacts.contacts = t_contactsArray
                            let menu = self.sideMenuController()?.sideMenu?.menuViewController as! SideMenuTableViewController
                            menu.foo()
                        })
                    }
                }
            }
                
            else{
//                self.contactsArray = []
//                self.allContactsTable.reloadData()
            }
        })
        
    }
    
    func foo(){
        tableView.reloadData()
        print("i am loggig from here")
        print(Contacts.contacts)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return Contacts.contacts.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.blackColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont(name:"Avenir", size:15)
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
//            selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
//        cell!.textLabel?.text = "ViewController #\(indexPath.row+1)"
        cell!.textLabel?.text = Contacts.contacts[indexPath.row].email
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        

        
//        //login 
//        myRootRef.createUser("bobtony1@example.com", password: "correcthorsebatterystaple",
//            withValueCompletionBlock: { error, result in
//                if error != nil {
//                    // There was an error creating the account
//                } else {
//                    let uid = result["uid"] as? String
//                    print("Successfully created user account with uid: \(uid)")
//                }
//        })
//        
//        
//        myRootRef.authUser("bobtony1@example.com", password: "correcthorsebatterystaple",
//            withCompletionBlock: { error, authData in
//                if error != nil {
//                     print("There is an error when loggin in")
//                } else {
//                    print("we are logged in")
//                }
//        })
        
        
        
        //Present new view controller
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController1")
            print("PPPPPPPP")
            break
        case 1:
//            destViewController = mainStoryboard.instfantiateViewControllerWithIdentifier("ViewController2")
            print("Finish case 1")
            break
        case 2:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController3")
            print("Finish case 2")
            break
        default:
            print("Finish case 3")
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4")
            break
        }
        
        toggleSideMenuView()
//        sideMenuController()?.setContentViewController(destViewController)

        print("Finish the loop")
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
