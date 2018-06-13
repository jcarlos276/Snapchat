//
//  SnapUserTableViewCell.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 6/13/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit

class SnapUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var typeEmoji: UILabel!
    var username = ""
    var isImage = true

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func loadContent() {
        containerView.layer.cornerRadius = 12.5
        contactLbl.text = username.components(separatedBy: "@").first
        if isImage {
            typeEmoji.text = "🏞"
        } else {
            typeEmoji.text = "🎙"
        }
    }
    
}
