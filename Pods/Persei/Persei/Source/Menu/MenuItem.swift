// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit.UIImage

public struct MenuItem {
    public var image: UIImage
    public var highlightedImage: UIImage?
    
    public var backgroundColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
//    public var highlightedBackgroundColor = UIColor(red: 1.0, green: 61.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    public var highlightedBackgroundColor = UIColor.orangeColor()
    
    public var shadowColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    
    // MARK: - Init
    public init(image: UIImage, highlightedImage: UIImage? = nil) {
        self.image = image
        self.highlightedImage = highlightedImage
    }
}
