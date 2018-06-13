//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/30/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import SVProgressHUD
import Firebase

class VerSnapViewController: UIViewController {
    
    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    
    var destinationUrl: URL? = URL(string: "")
    
    var snap = Snap()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
//        Storage.storage().reference().child("imagenes").child("\(snap.dataID).jpg").delete { (error) in
//            print("Se eliminó la imagen correctamente")
//        }
//    }
    
    func loadContent() {
        if snap.dataType == "image" {
            playButton.isHidden = true
            SVProgressHUD.show(withStatus: "Cargando imagen")
            snapImage.sd_setImage(with: URL(string: snap.dataURL)) { (image, error, cacheType, url) in
                SVProgressHUD.dismiss()
            }
        } else {
            let urlstring = snap.dataURL
            let url = URL(string: urlstring)!
            downloadResource(url: url) {
                self.play(url: self.destinationUrl!)
            }
        }
        descriptionLabel.text = snap.snapDescription
    }
    
    func downloadResource(url: URL, completion: @escaping() -> ()) {
        SVProgressHUD.show(withStatus: "Cargando audio")
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            SVProgressHUD.dismiss()
            guard let location = location, error == nil else { SVProgressHUD.showError(withStatus: error?.localizedDescription); return }
            do {
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                self.destinationUrl = documentsDirectoryURL.appendingPathComponent(self.snap.dataID)
                try FileManager.default.moveItem(at: location, to: self.destinationUrl!)
                completion()
                print("File moved to documents folder")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            SVProgressHUD.dismiss()
        }).resume()
    }
    
    func play(url: URL) {
        do {
            if audioPlayer == nil {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
            }
            if audioPlayer!.isPlaying {
                audioPlayer?.pause()
                playButton.setImage(#imageLiteral(resourceName: "Icon_3-512"), for: .normal)
            } else {
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = 1.0
                audioPlayer?.play()
                playButton.setImage(#imageLiteral(resourceName: "Pause-Transparent-Image"), for: .normal)
            }
        } catch let error as NSError {
            print(error.description)
            SVProgressHUD.showError(withStatus: "\(error.description)")
        } catch {
            SVProgressHUD.showError(withStatus: "Ocurrio un error al intentar reproducir el audio")
        }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        play(url: destinationUrl!)
    }
}

extension VerSnapViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setImage(#imageLiteral(resourceName: "Icon_3-512"), for: .normal)
    }
}
