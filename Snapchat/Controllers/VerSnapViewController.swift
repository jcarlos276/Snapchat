//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/30/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Firebase

class VerSnapViewController: UIViewController {
    
    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var snap = Snap()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete { (error) in
            print("Se eliminó la imagen correctamente")
        }
    }
    
    func loadContent() {
        SVProgressHUD.show(withStatus: "Cargando imagen")
        snapImage.sd_setImage(with: URL(string: snap.imagenURL)) { (image, error, cacheType, url) in
            SVProgressHUD.dismiss()
        }
        descriptionLabel.text = snap.snapDescription
    }

}
