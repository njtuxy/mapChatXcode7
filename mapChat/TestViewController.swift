//
//  TestViewController.swift
//  mapChat
//
//  Created by Yan Xia on 1/13/16.
//  Copyright © 2016 yxia. All rights reserved.
//

import Foundation
import Persei
import MapKit

class TestViewController: UITableViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    private weak var menu: MenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        loadMenu()
        
        
    }
    
    private func loadMenu() {
        let menu = MenuView()
        menu.backgroundColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
//        menu.backgroundColor = UIColor.whiteColor()
//        menu.backgroundImage = UIImage(named: "sideMenu-black")
        
        tableView.addSubview(menu)
        menu.delegate = self
        
//        let image = UIImage.fontAwesomeIconWithName(.User, textColor: UIColor.orangeColor(), size: CGSizeMake(50, 50))
        
        let image2 = UIImage(named: "menu_icon_0")
        
        let item1 = MenuItem(image: image2!)
        
        let item2 = MenuItem(image: image2!)

        let items = [item1, item2]

        
        menu.items = items     
        self.menu = menu
    }
    
    // MARK: - Items
//    private let items = (0..<7 as Range).map {_ in
//        MenuItem(image: UIImage(named: "contacts")!)
//    }
    
    // MARK: - Items
//    private let items = (0..<7 as Range).map {_ in 
//        MenuItem(image: UIImage(named: "contacts")!)        
//    }

    

    

    
    // MARK: - Actions
    @IBAction
    private func switchMenu() {
        menu.setRevealed(!menu.revealed, animated: true)
    }
    
    private var model: ContentType = ContentType.Films {
        didSet {
            title = model.description
            
            if isViewLoaded() {
                let center: CGPoint = {
                    
                    let itemFrame = self.menu.frameOfItemAtIndex(self.menu.selectedIndex!)
                    let itemCenter = CGPoint(x: itemFrame.midX, y: itemFrame.midY)
                    let convertedCenter1 = mapView.convertPoint(CGPointMake(0, 0), toCoordinateFromView: self.view)
                    let convertCenter = mapView.convertCoordinate(convertedCenter1, toPointToView: self.view)
                    
                    print(convertCenter)
                    
                    return convertCenter
                }()
                
                
                
                //                let transition = CircularRevealTransition(layer: imageView.layer, center: center)
                //                transition.start()
                //
                //                imageView.image = model.image
            }
        }
    }

}


// MARK: - MenuViewDelegate
extension TestViewController: MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) {
        model = model.next()
    }
}




