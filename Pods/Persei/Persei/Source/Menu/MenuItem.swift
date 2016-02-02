// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit.UIImage
import Firebase

public struct MenuItem {
    public var image: UIImage
    public var highlightedImage: UIImage?
    public var backgroundColor = UIColor.clearColor()
//    public var highlightedBackgroundColor = UIColor(red: 1.0, green: 61.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    public var highlightedBackgroundColor = UIColor.clearColor()
    public var shadowColor = UIColor.clearColor()
    public let  email: String
    public let  uid: String
    public let name:String

    // MARK: - Init
    public init(image: UIImage, email: String, uid: String, name:String) {
        self.image = image.circle!
        self.email = email
        self.uid = uid
        self.name = name
    }
}

extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        print(size.width)
        print(size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/8
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 157.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).CGColor        
        imageView.layer.borderWidth = 5
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    

}
