//
//  RoundedButton.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 6/13/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 15
    }

}
