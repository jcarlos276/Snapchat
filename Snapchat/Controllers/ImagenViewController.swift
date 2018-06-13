//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/16/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ImagenViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var chooseContactButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imageUrl = ""
    var imagenID = NSUUID().uuidString

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    @IBAction func cammeraTapped(_ sender: Any) {
        showOptionsOfImage()
    }
    
    @IBAction func chooseContactTapped(_ sender: Any) {
        if imageView.image == nil {
            showAlertWithTitle(title: "Alerta", withMessage: "Seleccione una imagen para subir", inViewCont: self)
            return
        }
        if descriptionTextField.text == "" {
            showAlertWithTitle(title: "Alerta", withMessage: "Ingrese una descripcion para su Snap", inViewCont: self)
            return
        }
        chooseContactButton.isEnabled = false
        let folderImages = Storage.storage().reference().child("imagenes")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        if imageUrl != "" {
            self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: imageUrl)
        } else {
            SVProgressHUD.show(withStatus: "Subiendo imágen")
            folderImages.child("\(imagenID).jpg").putData(imageData, metadata: nil) { (metadata, error) in
                self.chooseContactButton.isEnabled = true
                if error != nil {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    SVProgressHUD.dismiss()
                    self.imageUrl = (metadata?.downloadURL()!.absoluteString)!
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: self.imageUrl)
                }
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ElegirUsuarioViewController
        vc.imagenURL = sender as! String
        vc.snapDescription = descriptionTextField.text!
        vc.imagenID = imagenID
    }
    
    func configureContent() {
        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        chooseContactButton.layer.cornerRadius = 12.5
    }
    
    func showOptionsOfImage() {
        let actionsheet = UIAlertController(title: "Desea subir imágenes desde ...", message: nil, preferredStyle: .actionSheet)
        let selectGallery = UIAlertAction(title: "Galeria 🖼", style: .default) { (_) in
            self.selectFromGallery()
        }
        let takePhoto = UIAlertAction(title: "Cámara 📷", style: .default) { (_) in
            self.takePhoto()
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        actionsheet.addAction(selectGallery)
        actionsheet.addAction(takePhoto)
        actionsheet.addAction(cancel)
        present(actionsheet, animated: true, completion: nil)
    }
    
    func selectFromGallery() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            try! imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlertWithTitle(title: "Alerta", withMessage: "La cámara no está disponible en este dispositivo", inViewCont: self)
        }
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
