//
//  ChatViewController.swift
//  mapChat
//
//  Created by Yan Xia on 1/16/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase


class ChatViewController: JSQMessagesViewController, UIGestureRecognizerDelegate {
    
    //Firebase info
//    var rootRef:Firebase!
    var rootRef:Firebase!
    var messageRef:Firebase!
    var messageHandle:UInt!
    
    var email1:String = "a@a.com"
    var email2:String = "a@123.com"
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.setup()
//        self.addDemoMessages()
        self.initFirebase()
        
        self.getMessageWithThisUser(email1, otherUsersEmailAddress: email2)
        
        let singleTap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        singleTap.delegate = self
        self.collectionView?.addGestureRecognizer(singleTap)
        self.collectionView?.userInteractionEnabled = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = true
    }
    
    
    func dismissKeyboard(){
        print("tap found on view!")
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
}

//Firebase functions:
extension ChatViewController{
    
    func initFirebase(){
        rootRef = Firebase(url:"https://qd.firebaseio.com/messages")
        messageRef = rootRef.childByAppendingPath(getMessageUid(email1, emailAddress2: email2))
        print(messageRef)
    }
    
    func getMessageWithThisUser(myEmailAddress:String, otherUsersEmailAddress:String){
        let messageHandle = messageRef.queryLimitedToNumberOfChildren(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapShot) in

            let text = snapShot.value["text"] as? String
            let sender = snapShot.value["sender"] as? String
//            let imageUrl = snapShot.value["imageUrl"] as? String
            
//            let sender = (i%2 == 0) ? "Server" : self.senderId
//            let messageContent = "Message nr. \(i)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: text)
            print("messaeg is here:")
            print(message)
            self.messages += [message]
//            self.receivedMessagePressed()
//            self.reloadMessagesView()
            self.finishReceivingMessage()
        })
    }
    
    func sendMessage(text:String!, sender: String!){
        
        print("mesage sent to firebase!")
        messageRef.childByAutoId().setValue([
            "text": text,
            "sender": sender
        ])
    }
    
    
    
//    messagesRef.queryLimitedToNumberOfChildren(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
//    let text = snapshot.value["text"] as? String
//    let sender = snapshot.value["sender"] as? String
//    let imageUrl = snapshot.value["imageUrl"] as? String
//    
//    let message = Message(text: text, sender: sender, imageUrl: imageUrl)
//    self.messages.append(message)
//    self.finishReceivingMessage()
//    })
    
    
}

//General message methods:
extension ChatViewController{
    
    func getMessageUid(emailAddress1:String, emailAddress2: String) -> String{
        var emailAddress1 = emailAddress1.stringByReplacingOccurrencesOfString(".", withString: "DOT")
        var emailAddress2 = emailAddress2.stringByReplacingOccurrencesOfString(".", withString: "DOT")
        
        if(emailAddress1>emailAddress2){
            return (emailAddress1+"-"+emailAddress2)
        }else{
            return (emailAddress2+"-"+emailAddress1)
        }
        
    }

}

//MARK - Setup
extension ChatViewController {
    func addDemoMessages() {
//        for i in 1...10 {
//            let sender = (i%2 == 0) ? "Server" : self.senderId
//            let messageContent = "Message nr. \(i)"
//            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
//            self.messages += [message]
//        }
        

    }
    
    func setup() {
        self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
    }
    
}

//MARK - Data Source
extension ChatViewController {
    
    func receivedMessagePressed() {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    //Configure each cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.blackColor()
        } else {
            cell.textView!.textColor = UIColor.whiteColor()
        }

        let attributes = [NSForegroundColorAttributeName:cell.textView!.tintColor,NSUnderlineStyleAttributeName:1]
        cell.textView!.linkTextAttributes = attributes
        
        return cell
    }
    
    // Show  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = self.messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderId == senderId {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderId)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

}

//MARK - Toolbar
extension ChatViewController {
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.sendMessage(text, sender: senderId)
//        self.finishSendingMessage()
        self.reloadMessagesView()
        self.finishSendingMessage()

    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
    
}
