//
//  UserTableViewCell.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 6/13/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLbl: UILabel!
    var username = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        configureContent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func setSelectedStyle() {
        if isSelected {
            usernameLbl.font = UIFont(name: "DIN Alternate-Bold", size: 22.0)
            usernameLbl.font = UIFont.boldSystemFont(ofSize: 22.0)
        } else {
            usernameLbl.font = UIFont(name: "DIN Alternate", size: 20.0)
            
        }
    }
    
    func configureContent() {
        containerView.layer.cornerRadius = 12.5
    }
    
    func loadContent() {
        usernameLbl.text = username.components(separatedBy: "@").first
    }

}
