//
//  MapViewControllerNew.swift
//  mapChat
//
//  Created by Yan Xia on 1/15/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import MapKit
import UIKit

class ContactOnMap: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    
}
