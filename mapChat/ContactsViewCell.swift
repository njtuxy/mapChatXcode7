//
//  ContactsViewCell.swift
//  mapChat
//
//  Created by Yan Xia on 12/2/15.
//  Copyright © 2015 yxia. All rights reserved.
//

import UIKit

class ContactsViewCell: UITableViewCell {

    @IBOutlet weak var txtUserEmail: UILabel!
    
    @IBOutlet weak var btnRemoveContact: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
