//
//  ProfileTableViewController.swift
//  mapChat
//
//  Created by Yan Xia on 2/2/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profilePhoto: UIImageView!
    let imagepicker = UIImagePickerController()
    
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func editProfilePhoto(sender: AnyObject) {
        imagepicker.allowsEditing = false
        imagepicker.sourceType = .PhotoLibrary
        presentViewController(imagepicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.profilePhoto.image = Me.account.profilePhoto
        self.userName.text = Me.account.name
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profilePhoto.contentMode = .ScaleAspectFit
        let scaledImage = self.scaleUIImageToSize(image, size: CGSizeMake(200.0, 200.0))
        profilePhoto.image = scaledImage
        dismissViewControllerAnimated(true, completion: nil)
        uploadProfilePhotoToFirebase(scaledImage)
    }
    
    func uploadProfilePhotoToFirebase(image: UIImage){
        FirebaseHelper.rootRef.childByAppendingPath("users").childByAppendingPath(Me.account.uid).childByAppendingPath("profilePhoto").setValue(image.toBase64())
        Me.account.profilePhoto = image
    }
}

extension UIImage{
    func toBase64() -> String{
        let imageData = UIImagePNGRepresentation(self)!
        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}

extension ProfileTableViewController{
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    /*
    Image Resizing Techniques: http://bit.ly/1Hv0T6i
    */
    func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
