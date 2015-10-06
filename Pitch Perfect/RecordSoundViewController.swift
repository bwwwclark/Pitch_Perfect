//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Benjamin Clark  on 9/17/15.
//  Copyright (c) 2015 Benjamin Clark . All rights reserved.
//

import UIKit

import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
  
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var RecordingLabel: UILabel!

    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var PauseButton: UIButton!
    
    @IBOutlet var ResumeButton: UIButton!
    
    @IBOutlet var PauseLabel: UILabel!
    
    @IBOutlet var ResumeLabel: UILabel!
    
    

   //set variables from AVAudioRecorder and RecordedAudio
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        RecordingLabel.text = "Tap to Record"
        stopButton.hidden = true
        PauseButton.hidden = true
        ResumeButton.hidden = true
        ResumeLabel.hidden = true
        PauseLabel.hidden = true
        PauseButton.enabled = true

    }
    @IBAction func RecordAudio(sender: AnyObject) {
        
        //set path for Audio recording
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var recordingName = "my_audio.wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Use AVAudioRecorder to record audio and save to the path set above
        
        audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:], error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
       
        //print to the log when recording is successfully started
        
        println("Recording audio")
        
        // Change Recording Label text to "Recording" while recording audio
        RecordingLabel.text = "Recording..."
        stopButton.hidden = false
        PauseButton.hidden = false
        ResumeButton.hidden = false
        recordButton.enabled = false
        PauseLabel.hidden = false
        ResumeButton.hidden = false
        ResumeButton.enabled = false
        

    }
    
    
    //Segue to PlaySounds view controller when Audio stops recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
            if(flag){
            var recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording",sender: recordedAudio)
        
    }else {
    // print message to the logs if recording is not successful
        println("recording was not successful")
        recordButton.enabled = true
    stopButton.hidden = true
    }

    }
    
    //Send recorded audio to the Play Sounds View Controller upon segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
           let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    // Stop recording when the stop button is hit.
    
    @IBAction func StopButton(sender: AnyObject) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        audioRecorder.stop()
        

        RecordingLabel.text = ""
        recordButton.enabled = true
    
        
    }
    
    @IBAction func PauseButton(sender: AnyObject) {
        audioRecorder.pause()
        RecordingLabel.text = "Paused..."
        PauseButton.enabled = false
        ResumeButton.enabled = true
        ResumeLabel.hidden = false
        PauseLabel.hidden = false
        
    }
    
    @IBAction func ResumeButton(sender: AnyObject) {
        audioRecorder.record()
        RecordingLabel.text = "Recording..."
        PauseButton.enabled = true
        ResumeButton.enabled = false
        
        
        
    }
    
    }

    


