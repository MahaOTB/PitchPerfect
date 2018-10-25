//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Maha on 16/10/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //UI outlet
    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnRecording: UIButton!
    @IBOutlet weak var btnStopRecording: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let SettingsAlert = "Settings"
        static let RecordingErrorTitle = "Faild Recording"
        static let RecordingErrorMessage = "Problem occurred during the recording process please try again"
        static let MicrophonePermissionDenied = "To record voice Pitch Perfect needs to access to microphone. Go to Settings-> Privecy-> Microphone and turn on Pitch Perfect"
        static let MicrophoneSettingsMessage = "To record voice Pitch Perfect needs to access to microphone. Tap on Settings and turn on Pitch Perfect"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnStopRecording.isEnabled = false
    }
    
    //This function called when btnRecording pressesd to record the voice
    @IBAction func RecordingVoice(_ sender: Any) {
        let session = AVAudioSession.sharedInstance()
        //Prompt users to allow microphone access
        session.requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                
                //Record audio if microphone garanted
                self.configurUI(recordingState: true)
                
                let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let recordingName = "recordedVoice.wav"
                let pathArray = [dirPath, recordingName]
                let filePath = URL(string: pathArray.joined(separator: "/"))
                
                try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default , options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                try! self.audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                self.audioRecorder.delegate = self
                self.audioRecorder.isMeteringEnabled = true
                self.audioRecorder.prepareToRecord()
                self.audioRecorder.record()
            } else {
                
                //Prompt users to turn on Microphone settings
                if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                    let settingsAction = UIAlertAction(title: Alerts.SettingsAlert , style: .default, handler: {
                        action in UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    })
                    self.showAlert(Alerts.MicrophoneSettingsMessage, actionOfSecondBtn: settingsAction)
                } else {
                    self.showAlert(Alerts.MicrophonePermissionDenied)
                }
            }
        })
    }
    
    //This function called when btnStopRecording pressesd to stop the voice
    @IBAction func stopRecording(_ sender: Any) {
        configurUI(recordingState: false)
        audioRecorder.stop()
        let audioSesion = AVAudioSession.sharedInstance()
        try! audioSesion.setActive(false)
    }
    
    //This function used to ensure that the audio recorder finished recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else{
            showAlert(Alerts.RecordingErrorTitle , message: Alerts.RecordingErrorMessage)
        }
    }
    
    //This function used to prepare segue before navigating to PlaySoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue"  {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    //This function used to change the UI states: True -> Recording , False -> Stopped recording
    func configurUI (recordingState: Bool){
        if recordingState {
            btnRecording.isEnabled = !recordingState
            btnStopRecording.isEnabled = recordingState
        } else {
            btnRecording.isEnabled = !recordingState
            btnStopRecording.isEnabled = recordingState
        }
        lblRecording.text = recordingState ?
            "Tap to Stop Recording" : "Tap to Start Recording"
    }
    
    func showAlert(_ title: String, message: String = "", actionOfSecondBtn: UIAlertAction? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        if let actionBtn = actionOfSecondBtn {
            alert.addAction(actionBtn)
        }
            self.present(alert, animated: true, completion: nil)
    }
}

