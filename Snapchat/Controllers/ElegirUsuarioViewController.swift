//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/23/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var usuarios: [Usuario] = []
    var imagenURL = ""
    var snapDescription = ""
    var imagenID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
        loadContent()
    }
    
    func configureContent() {
        tableView.delegate = self
    }
    
    func loadContent() {
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded) { (snapshot) in
            let usuario = Usuario()
            usuario.uid = snapshot.key
            usuario.email = (snapshot.value as! Dictionary<String, Any>)["email"] as! String
            if Auth.auth().currentUser!.email! != usuario.email {
                self.usuarios.append(usuario)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendSnaps(_ sender: Any) {
        for indexPath in tableView.indexPathsForSelectedRows! {
            let usuario = usuarios[indexPath.row]
            let snap = ["imagenID":imagenID, "from": Auth.auth().currentUser!.email, "descripcion": snapDescription, "imagenURL": imagenURL]
            Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
            navigationController?.popToRootViewController(animated: true)
        }
    }

}

extension ElegirUsuarioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
}
