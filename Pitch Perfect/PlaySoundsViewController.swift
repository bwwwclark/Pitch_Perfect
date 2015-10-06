//
//  playSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Benjamin Clark  on 9/26/15.
//  Copyright (c) 2015 Benjamin Clark . All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    ///initialize variables from AVAudioPlayer, RecordedAudio, AVAudioEngine and AVAudioFile
    var audioPlayer = AVAudioPlayer()
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///  Load Audio received from the Record Sounds View Controller, enable rate changes
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        var rate: Float
        audioPlayer.prepareToPlay()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /// Dispose of any resources that can be recreated.
    }
    
    
    // set slow rate and play slow audio for the slow button
    @IBAction func PlaySlowButton(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
        
    }
    // set fast rate and play fast audio for the slow button
    @IBAction func PlayFastButton(sender: AnyObject) {
        playAudioWithVariableRate(1.5)
    }
    // set high pitch and play high pitched audio for the slow button
    @IBAction func PlayChipmunkVoiceButton(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    // set low pitch and play low pitched audio for the slow button
    @IBAction func PlayDarthVaderVoiceButton(sender: AnyObject) {
        playAudioWithVariablePitch(-700)
        
    }
    
    
    @IBAction func ReverbVoiceButton(sender: AnyObject) {
    }
    
    /// function that varies the rate of recorded audio for playback
    func playAudioWithVariableRate(rate: Float){
        stopAudioPlay()
        audioPlayer.rate = rate
        audioPlayer.play()
        
    }
    /// function that varies the pitch of recorded audio for playback
    func playAudioWithVariablePitch(pitch: Float){
        stopAudioPlay()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    ///defines all the actions to take when the audio is stopped
    func stopAudioPlay(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        
    }
    
    ///Code to stop playback when Stop button is tapped.
    
    @IBAction func StopAudioPlay(sender: AnyObject) {
        stopAudioPlay()
        
        
    }
    
}


