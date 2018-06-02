//
//  SonidoViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Guillén Castro on 5/30/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import SVProgressHUD

class SonidoViewController: UIViewController {
    
    @IBOutlet weak var snapDescription: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var chooseContactButton: UIButton!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioLocalURL: URL?
    
    var sonidoUrl = ""
    var isPlaying = false
    
    var sonidoID = NSUUID().uuidString

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    func configureContent() {
        setupRecorder()
    }
    
    func setupRecorder() {
        do {
            //Creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Creando una dirección para el archivo de audio
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioLocalURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("-------------------------AudioURL-------------------------")
            print(audioLocalURL!)
            print("-------------------------*-------------------------")
            
            //Crear opciones para el grabador de audio
            var settings: [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabación de audio
            audioRecorder = try AVAudioRecorder(url: audioLocalURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if audioRecorder!.isRecording {
            //Detener la grabación
            audioRecorder?.stop()
            //Cambiar el texto del botón grabar
            playButton.setImage(#imageLiteral(resourceName: "Icon_3-512"), for: .normal)
            playButton.isEnabled = true
        } else {
            //Empezar a grabar
            audioRecorder?.record()
            //Cambiar el titulo del botón a detener
            playButton.setImage(#imageLiteral(resourceName: "Button-Stop-512"), for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        do {
            if audioPlayer == nil {
                try audioPlayer = AVAudioPlayer(contentsOf: audioLocalURL!)
                audioPlayer?.delegate = self
            }
            if !(audioPlayer!.isPlaying) {
                audioPlayer!.play()
                playButton.setTitle("Pause", for: .normal)
            } else {
                audioPlayer!.pause()
                playButton.setTitle("Play", for: .normal)
            }
        } catch {}
    }
    
    @IBAction func chooseContactTapped(_ sender: Any) {
        let folderSounds = Storage.storage().reference().child("sonidos")
        let soundData = NSData(contentsOf: audioLocalURL!) as Data?
        
        if soundData == nil {
            showAlertWithTitle(title: "Alerta", withMessage: "Grabe un audio para subir", inViewCont: self)
            return
        }
        if snapDescription.text == "" {
            showAlertWithTitle(title: "Alerta", withMessage: "Ingrese una descripcion para su Snap", inViewCont: self)
            return
        }
        chooseContactButton.isEnabled = false
        
        if sonidoUrl != "" {
            self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: sonidoUrl)
        } else {
            SVProgressHUD.show(withStatus: "Subiendo audio")
            folderSounds.child("\(sonidoID).m4a").putData(soundData!, metadata: nil) { (metadata, error) in
                self.chooseContactButton.isEnabled = true
                if error != nil {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    SVProgressHUD.dismiss()
                    self.sonidoUrl = (metadata?.downloadURL()!.absoluteString)!
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: self.sonidoUrl)
                }
            }
        }
    }

}

extension SonidoViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: .normal)
    }
}
