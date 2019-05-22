//
//  GloableSiriFunc.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 3/27/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS
import AVFoundation

protocol GloableSiriFuncDelegate: class{
    func gloableSiriFuncTextReturn(text: String)
    func gloableSiriFuncOpenCarloudyNewsWasSaid()
}

class GloableSiriFunc: NSObject {
    public static let shareInstance: GloableSiriFunc = GloableSiriFunc()
    let carloudyBLE = CarloudyBLE.shareInstance
    var falseIndex = 0
    weak var delegate: GloableSiriFuncDelegate?
    fileprivate let warningText = "9"
    
    //提醒用户正在听
    fileprivate let liseningText = "8"
}

extension GloableSiriFunc{
    
    func startNewSession(){
        if let pairkey = carloudyBlePairKey_{
            carloudyBLE.newKeySendToPairAndorid_ = pairkey
        }
        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
    }
    
    func sendMessageToCarloudy(title: String, content: String = ""){
        carloudyBLE.sendMessage(textViewId: "3", message: title)
        let number = Int.random(in: 0 ..< 100)
        carloudyBLE.sendMessage(textViewId: "x", message: "\(number)")
        startNewSession()           //fangzhiqingping
        
        carloudyBLE.sendMessage(textViewId: "3", message: title)
        
//        if content != ""{
//            carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "4", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
//            carloudyBLE.sendMessage(textViewId: "4", message: content)
//        }
    }
    
    func sendOpenListeningLableToCarloudy(str: String = "Listen"){
//        carloudyBLE.sendMessage(textViewId: liseningText, message: str)
        carloudyBLE.createPictureIDAndImageViewForCarloudyHUD(picID: "yy", postionX: 02, postionY: 02, width: 05, height: 00)
        
    }
    func sendCloseListeningLableToCarloudy(str: String = ""){
//        carloudyBLE.sendMessage(textViewId: liseningText, message: str)
    }
    
    func createLabelsInCarloudy(){
        
        startNewSession()
        startNewSession()
        
        let waringTextSize = 30
        let labelTextSize = 40
        let carloudyBLE = CarloudyBLE.shareInstance
        if let pairkey = carloudyBlePairKey_{
            carloudyBLE.newKeySendToPairAndorid_ = pairkey
        }
        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "3", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "3", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "x", labelTextSize: waringTextSize, postionX: 02, postionY: 05, width: 05, height: 00)
//        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: liseningText, labelTextSize: waringTextSize, postionX: 02, postionY: 02, width: 05, height: 00)
        sendOpenListeningLableToCarloudy()
        sendOpenListeningLableToCarloudy()
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: warningText, labelTextSize: waringTextSize, postionX: 05, postionY: 65, width: 00, height: 00)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: warningText, labelTextSize: waringTextSize, postionX: 05, postionY: 65, width: 00, height: 00)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "3", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "3", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
        
    }
    
    func sendWaringLabelToCarloudy(title: String){
        CarloudyBLE.shareInstance.sendMessage(textViewId: warningText, message: title)
    }
    
    
    func startGlobleHeyCarloudyNews(vc: UIViewController){
        if !isEnableOpenCarloudyNews{return}
        if carloudySpeech.audioEngine.isRunning{
            return
        }
        
        
        carloudySpeech.microphoneTapped()
        sendOpenListeningLableToCarloudy()
        
        globleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            ZJPrint(carloudySpeech.checkText().lowercased())
            testView.text = carloudySpeech.checkText().lowercased()
            ZJPrint(carloudySpeech.audioEngine.isRunning)
            if !carloudySpeech.audioEngine.isRunning{
                self.falseIndex += 1
                if self.falseIndex >= 5 {
                    self.stopGlobleHeyCarloudyNews()
                    let alert = UIAlertController(title: "Warning", message: "Listen for 'category' is not working now, please restart and try again", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    vc.present(alert, animated: true, completion: nil)
                    return
                }
                self.stopGlobleHeyCarloudyNews()
                self.startGlobleHeyCarloudyNews(vc: vc)
                return
            }
            self.falseIndex = 0
            self.delegate?.gloableSiriFuncTextReturn(text: carloudySpeech.checkText().lowercased())
            if carloudySpeech.checkText().lowercased().contains("category") || carloudySpeech.checkText().lowercased().contains("choose category") || carloudySpeech.checkText().lowercased().contains("choose a category"){
                self.sendCloseListeningLableToCarloudy()
                self.playSound(soundName: "beep_short_off")
                self.stopGlobleHeyCarloudyNews()
                self.delegate?.gloableSiriFuncOpenCarloudyNewsWasSaid()
                let storyboard = UIStoryboard(name: "PrimaryViewController", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PrimaryViewController")
                let nvc = UINavigationController(rootViewController: controller)
                vc.present(nvc, animated: true, completion: nil)
            }else if carloudySpeech.checkText().lowercased().contains("open carloudy"){
                self.sendCloseListeningLableToCarloudy()
                self.playSound(soundName: "beep_short_off")
                if let url = URL(string: "com.CognitiveAI.Carloudy://"){
                    if UIApplication.shared.canOpenURL(url){
                        self.stopGlobleHeyCarloudyNews()
                        //打开carloudy之前，清除所有现在的信息
                        CarloudyBLE.shareInstance.sendAppCommand(commandID: "0", appId: carloudyAppStoreAppKey_)
                        CarloudyBLE.shareInstance.sendAppCommand(commandID: "0", appId: carloudyAppStoreAppKey_)
//                        self.startGlobleHeyCarloudyNews(vc: UIApplication.topViewController()!)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
    
    func stopGlobleHeyCarloudyNews(stopOnce: Bool = false){
        if !isEnableOpenCarloudyNews && stopOnce == false{return}
        carloudySpeech.endMicroPhone()
        globleTimer?.invalidate()
        globleTimer = nil
    }
    
    func playSound(soundName : String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        do {
            //            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            //            try AVAudioSession.sharedInstance().setActive(true)
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            var player: AVAudioPlayer?
//            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//            guard let player = player else { return }
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
