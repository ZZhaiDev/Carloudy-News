//
//  GloableSiriFunc.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 3/27/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS

protocol GloableSiriFuncDelegate: class{
    func gloableSiriFuncTextReturn(text: String)
}

class GloableSiriFunc: NSObject {
    public static let shareInstance: GloableSiriFunc = GloableSiriFunc()
    var falseIndex = 0
    weak var delegate: GloableSiriFuncDelegate?
}

extension GloableSiriFunc{
    func sendMessageToCarloudy(title: String, content: String = ""){
        let labelTextSize = 40
        let carloudyBLE = CarloudyBLE.shareInstance
        if let pairkey = carloudyBlePairKey_{
            carloudyBLE.newKeySendToPairAndorid_ = pairkey
        }
        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "3", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
        carloudyBLE.sendMessage(textViewId: "3", message: title)
        
        if content != ""{
            carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "4", labelTextSize: labelTextSize, postionX: 05, postionY: 05, width: 80, height: 00)
            carloudyBLE.sendMessage(textViewId: "4", message: content)
        }
    }
    
    
    func startGlobleHeyCarloudyNews(vc: UIViewController){
        if !isEnableOpenCarloudyNews{return}
        
        carloudySpeech.microphoneTapped()
        
        globleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            ZJPrint(carloudySpeech.checkText().lowercased())
            ZJPrint(carloudySpeech.audioEngine.isRunning)
            if !carloudySpeech.audioEngine.isRunning{
                self.falseIndex += 1
                if self.falseIndex >= 5 {
                    self.stopGlobleHeyCarloudyNews()
                    let alert = UIAlertController(title: "Warning", message: "Listen for 'Open CarloudyNews' is not working now, please restart and try again", preferredStyle: UIAlertController.Style.actionSheet)
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
            if carloudySpeech.checkText().lowercased().contains("open carloudynews"){
                self.stopGlobleHeyCarloudyNews()
                let storyboard = UIStoryboard(name: "PrimaryViewController", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PrimaryViewController")
                let nvc = UINavigationController(rootViewController: controller)
                vc.present(nvc, animated: true, completion: nil)
            }else if carloudySpeech.checkText().lowercased().contains("read the news"){
                
            }
        })
    }
    
    func stopGlobleHeyCarloudyNews(stopOnce: Bool = false){
        if !isEnableOpenCarloudyNews && stopOnce == false{return}
        carloudySpeech.endMicroPhone()
        globleTimer?.invalidate()
        globleTimer = nil
    }
}
