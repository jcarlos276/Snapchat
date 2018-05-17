//
//  iniciarSesionViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/16/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Iniciando sesión")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (user, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                self.showAlertWithOptions(withMessage: "\(error!.localizedDescription)", withOkHandler: {
                    self.createUser()
                }, inViewController: self)
            } else {
                SVProgressHUD.showSuccess(withStatus: "Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }
        }
    }
    
    func createUser() {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextfield.text!, completion: { (user, error) in
            if error != nil {
                self.showAlertWithTitle(title: "Alerta", withMessage: "\(error!.localizedDescription)", inViewCont: self)
            } else {
                SVProgressHUD.showSuccess(withStatus: "Fuiste registrado exitosamente")
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }
        })
    }
    
}

