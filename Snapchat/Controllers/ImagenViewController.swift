//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/16/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit

class ImagenViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var chooseContactButton: UIButton!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func cammeraTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            try! imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlertWithTitle(title: "Alerta", withMessage: "La cámara no está disponible en este dispositivo", inViewCont: self)
        }
    }
    
    @IBAction func chooseContactTapped(_ sender: Any) {
        
    }

}

extension ImagenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage!
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
