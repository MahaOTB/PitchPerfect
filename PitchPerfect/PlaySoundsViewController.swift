//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Maha on 18/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //UI outlet
    @IBOutlet weak var btnSlow: UIButton!
    @IBOutlet weak var btnFast: UIButton!
    @IBOutlet weak var btnHighPitch: UIButton!
    @IBOutlet weak var btnLowPitch: UIButton!
    @IBOutlet weak var btnEcho: UIButton!
    @IBOutlet weak var btnReverb: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    //this function called when sound buttons pressed to play the audio
    @IBAction func playSoundForButton (_ sender: UIButton){
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    //this function called when btnStop pressed to stop playing the audio
    @IBAction func StopButtonPressed (_ sender: UIButton){
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Change imageView inside the button to scaleAspectFit
        btnSlow.imageView?.contentMode = .scaleAspectFit
        btnFast.imageView?.contentMode = .scaleAspectFit
        btnHighPitch.imageView?.contentMode = .scaleAspectFit
        btnLowPitch.imageView?.contentMode = .scaleAspectFit
        btnEcho.imageView?.contentMode = .scaleAspectFit
        btnReverb.imageView?.contentMode = .scaleAspectFit
        
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
}
