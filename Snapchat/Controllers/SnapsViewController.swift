//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/16/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SnapsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageLbl: UILabel!
    
    var snaps: [Snap] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
        loadContent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let vc = segue.destination as! VerSnapViewController
            vc.snap = sender as! Snap
        }
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        self.view.window?.rootViewController = vc
        return
    }
    
    func configureContent() {
        tableView.delegate = self
        if snaps.count == 0 {
            messageLbl.isHidden = false
        } else {
            messageLbl.isHidden = true
        }
        tableViewHeight.constant = CGFloat(snaps.count*100)
    }
    
    func loadContent() {
        
        SVProgressHUD.show(withStatus: "Cargando Snaps")
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded) { (snapshot) in
            SVProgressHUD.dismiss()
            let snap = Snap()
            
            if let imagenURL = (snapshot.value as! Dictionary<String, Any>)["imagenURL"] as? String {
                snap.dataURL = imagenURL
                snap.dataID = (snapshot.value as! Dictionary<String, Any>)["imagenID"] as! String
                snap.dataType = "image"
            }
            if let sonidoURL = (snapshot.value as! Dictionary<String, Any>)["sonidoURL"] as? String {
                snap.dataURL = sonidoURL
                snap.dataID = (snapshot.value as! Dictionary<String, Any>)["sonidoID"] as! String
                snap.dataType = "audio"
            }
            snap.from = (snapshot.value as! Dictionary<String, Any>)["from"] as! String
            snap.snapDescription = (snapshot.value as! Dictionary<String, Any>)["descripcion"] as! String
            snap.id = snapshot.key
            
            self.snaps.append(snap)
            self.configureContent()
            self.tableView.reloadData()
            
            Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
                var iterador = 0
                for snap in self.snaps {
                    if snap.id == snapshot.key {
                        self.snaps.remove(at: iterador)
                    }
                    iterador += 1
                }
                self.configureContent()
                self.tableView.reloadData()
            })
        }
    }
    
}

extension SnapsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SnapUserTableViewCell") as! SnapUserTableViewCell
        let snap = snaps[indexPath.row]
        cell.username = snap.from
        cell.isImage = snap.dataType == "image" ? true : false
        cell.loadContent()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
}
