//
//  iniciarSesionViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/16/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SVProgressHUD

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        if validFields() {
            SVProgressHUD.show(withStatus: "Iniciando sesión")
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (user, error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    self.showAlertWithOptions(withMessage: "La cuenta con la que intentaste iniciar sesión no existe. ¿Deseas registrarte?", withOkHandler: {
                        self.createUser()
                    }, inViewController: self)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "Inicio de sesión exitoso")
                    self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
                }
            }
        }
    }
    
    func validFields() -> Bool {
        if emailTextField.text == "" {
            showAlertWithTitle(title: "Alerta", withMessage: "Por favor ingrese un correo", inViewCont: self)
            return false
        }
        if !emailTextField.isValidEmail() {
            showAlertWithTitle(title: "Alerta", withMessage: "Por favor ingrese un correo válido", inViewCont: self)
            return false
        }
        if passwordTextfield.text == "" {
            showAlertWithTitle(title: "Alerta", withMessage: "Por favor ingrese su contraseña", inViewCont: self)
            return false
        }
        return true
    }
    
    func configureContent() {
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        passwordTextfield.delegate = self
        emailTextField.setAttributedPlaceholder(with: "Email")
        passwordTextfield.setAttributedPlaceholder(with: "Password")
    }
    
    func createUser() {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextfield.text!, completion: { (user, error) in
            if error != nil {
                self.showAlertWithTitle(title: "Alerta", withMessage: "\(error!.localizedDescription)", inViewCont: self)
            } else {
                Database.database().reference().child("usuarios").child(user!.uid).child("email").setValue(user!.email)
                SVProgressHUD.showSuccess(withStatus: "Fuiste registrado exitosamente")
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }
        })
    }
    
}


//MARK: - UITextFieldDelegate
extension iniciarSesionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextfield.becomeFirstResponder()
        }
        if textField.returnKeyType == .go {
            iniciarSesionTapped("")
        }
        return true
    }
}

