//
//  NewContactTableViewCell.swift
//  mapChat
//
//  Created by Yan Xia on 12/1/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit

class NewContactTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var txtUserEmail: UILabel!
    @IBOutlet weak var btnAddContact: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
