//
//  CarloudySpeech.swift
//  CarloudyiOS
//
//  Created by Cognitive AI Technologies on 5/14/18.
//  Copyright © 2018 zijia. All rights reserved.
//

import UIKit
import Speech

open class CarloudySpeech: NSObject, SFSpeechRecognizerDelegate {
    
    public let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    public let audioSession = AVAudioSession.sharedInstance()
    public let audioEngine = AVAudioEngine()
    open var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    open var recognitionTask: SFSpeechRecognitionTask?
    lazy var inputNode = audioEngine.inputNode
    open var text_copy_ = ""
    open var text_ = ""
    
    
    open func initSetUp(){
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
        }
    }
    
    open func microphoneTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            initSetUp()
            startRecording()
        }
    }
    
    open func endMicroPhone(){
        if audioEngine.isRunning {
            do{
                let category = AVAudioSessionCategoryPlayback
                let categoryOptions: AVAudioSessionCategoryOptions = [.duckOthers, .interruptSpokenAudioAndMixWithOthers]
                try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeSpokenAudio)
                try AVAudioSession.sharedInstance().setCategory(category, with: categoryOptions)
            }catch{
                
            }
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
            
            inputNode.removeTap(onBus: 0)
            inputNode.reset()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recognitionTask?.cancel()
            recognitionTask = nil
            recognitionRequest = nil
        }
    }
    
    open func startRecording() {
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        //2
        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try audioSession.setMode(AVAudioSessionModeMeasurement)
//            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try audioSession.setMode(AVAudioSessionModeDefault)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
//        let inputNode = audioEngine.inputNode   //4
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        recognitionRequest.shouldReportPartialResults = true  //6
        text_ = ""
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            var isFinal = false  //8
            if result != nil {
                self.text_ = (result?.bestTranscription.formattedString)!.lowercased()  //9
                isFinal = (result?.isFinal)!
            }
            
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                self.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        var tempBool = false
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            if tempBool == false{
                tempBool = true
            }
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    open func checkText() ->String{
        return text_
    }
    
    open func checkTextChanging() -> Bool{
        if text_ != text_copy_{
            text_copy_ = text_
            return true
        }
        return false
    }
    
}


