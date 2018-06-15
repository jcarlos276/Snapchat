//
//  UITextField + Helpers.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 6/13/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setAttributedPlaceholder(with placeholder:String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6646318948, green: 0.8870894679, blue: 0.9361318211, alpha: 1)])
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text!)
    }
}
