//
//  UIViewController + Helpers.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/16/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWithTitle(title:String, withMessage message:String, withOkButtonTitle okButtonTitle:String = "OK", withOkHandler handler:((_ alertAction:UIAlertAction) -> Void)? = nil, inViewCont viewCont:UIViewController){
        let alertCont = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCont.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: handler))
        viewCont.present(alertCont, animated: true, completion: nil)
    }
    
    func showAlertWithOptions(withMessage message: String, withOkHandler handler:@escaping () -> Void, inViewController viewController: UIViewController) {
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            handler()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okay)
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func downloadFileFromURL(url:URL, failureResponse failure: @escaping(Error) -> Void, successResponse success: @escaping(URL) -> Void) {
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) in
            if error != nil {
                failure(error!)
            } else {
                success(URL!)
            }
        })
        
        downloadTask.resume()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
