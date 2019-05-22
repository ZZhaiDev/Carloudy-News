//
//  DrawViewController+Siri.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 4/2/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS
import AVFoundation

private let topics = ["business",
                      "entertainment",
                      "health",
                      "science",
                      "sports",
                      "technology"]

private var dataGotFromSiri = ""
private var currentSpeakingNews = ""


extension DrawerViewController{
    func startSiriSpeech(){
        animationview.start()
        carloudySpeech.microphoneTapped()
        self.createTimerForBaseSiri_checkText()
        self.delay3Seconds_createTimer()
        //        siriButton.setTitle("listening", for: .normal)
        //        siriButton.setTitleColor(UIColor.red, for: .normal)
        //        siriButton.isEnabled = false
    }
    
    func endSiriSpeech(){
        animationview.stop()
        carloudySpeech.endMicroPhone()
        ZJPrint("//// -----\(timer_checkTextIfChanging?.isValid)")
        timer_checkTextIfChanging?.invalidate()
        timer_forBaseSiri_inNavigationController?.invalidate()
        timer_checkTextIfChanging = nil
        timer_forBaseSiri_inNavigationController = nil
        ZJPrint("//// -----\(timer_checkTextIfChanging?.isValid)")
    }
    
    func endSendingData(){
        self.timer_sendingData?.invalidate()
        self.timer_sendingData = nil
    }
    
    func dismissContoller(delay: Int = 0){
        if synthesizer.isSpeaking{
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        synthesizer.delegate = nil
        clearScreen()
        endSendingData()
        endSiriSpeech()
        GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_openCarloudyNewsOrReadNews)
        GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_openCarloudyNewsOrReadNews)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            if let parentVC = self.parent as? PrimaryViewController{
                parentVC.dismiss(animated: true, completion: {
                    ZJPrint(UIApplication.topViewController())
                    if let vc = UIApplication.firstViewController() as? LikeViewController{
                        ZJPrint(vc)
                        startGlobleHeyCarloudyNews(vc: vc)
                    }
                })
            }
        }
        
    }
    
    
    fileprivate func delay3Seconds_createTimer(){
        let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if carloudySpeech.audioEngine.isRunning == true{
                self.createTimerForBaseSiri_checkiftextChanging()
            }
        }
    }
    
    fileprivate func createTimerForBaseSiri_checkiftextChanging(){
        if timer_checkTextIfChanging == nil{
            timer_checkTextIfChanging?.invalidate()
            timer_checkTextIfChanging = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(checkTextIsChanging), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func createTimerForBaseSiri_checkText(){
        if timer_forBaseSiri_inNavigationController == nil{
            timer_forBaseSiri_inNavigationController?.invalidate()
            timer_forBaseSiri_inNavigationController = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self](_) in
                self?.textReturnedFromSiri = (carloudySpeech.checkText().lowercased())
                //let result = self?.textReturnedFromSiri
                if self?.textReturnedFromSiri != ""{
                    self?.createTimerForBaseSiri_checkiftextChanging()
                }
            })
            
        }
        
    }
    
    @objc func checkTextIsChanging(){
        ZJPrint("//// -----checkTextIsChanging")
        ZJPrint("//// -----\(timer_checkTextIfChanging?.isValid)")
        
        guard carloudySpeech.checkTextChanging() == false else {return}
        ZJPrint(self.textReturnedFromSiri)
        if self.textReturnedFromSiri != ""{
            endSiriSpeech()
            
            if self.textReturnedFromSiri.lowercased().contains("close") || self.textReturnedFromSiri.lowercased().contains("stop"){
                ZJPrint("2222222222------------------------------------------------------------------------------------")
                speak(string: okcloseSpeech)
                return
            }
            
            UIView.animate(withDuration: 0.5) {
                //                self.imageViewWidthConstraint.constant = 120
                //                self.imageViewHeightConstraint.constant = 120
                self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            imageView.startAnimating()
            
            speak(string: searchingSpeech + "`\(self.textReturnedFromSiri)`")
            loadData(topic: self.textReturnedFromSiri)
            
        }else{      //长时间没说话
            ZJPrint("//// -----return1111")
            if (UIApplication.topViewController() as? LikeViewController) != nil{
                ZJPrint(timer_checkTextIfChanging?.isValid)
                timer_checkTextIfChanging?.invalidate()
                timer_checkTextIfChanging = nil
                ZJPrint(timer_checkTextIfChanging?.isValid)
                ZJPrint("//// -----return")
                return
            }
            //MARK: -- 这里有问题，dismiss 后重开 会说closespeech
            ZJPrint("//// -----closeSpeech")
            speak(string: closeSpeech)
            endSiriSpeech()
            
        }
    }
    
    fileprivate func createTimer_sendingData() {
        let articles: [Article] = self.homeViewModel.articles
        
        if self.timer_sendingData == nil{
            self.timer_sendingData?.invalidate()
            let maxIndex = articles.count
            let article = articles[self.sendingDataIndex]
            self.sendingDataIndex += 1
            if let title = article.title{
                sendMessageToCarloudy(title: title)
                if self.isStartReadTheNews == true{
                    currentSpeakingNews = title.lowercased()
                    self.speak(string: title.lowercased())
                    return
                }
            }
            self.timer_sendingData = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterVal), repeats: true, block: { (_) in
                
                if self.isStartReadTheNews == true{
                    self.timer_sendingData?.invalidate()
                    self.timer_sendingData = nil
                    return
                }
                
                let article = articles[self.sendingDataIndex]
                if let title = article.title{
                    sendMessageToCarloudy(title: title)
                }
                self.sendingDataIndex += 1
                if self.sendingDataIndex >= maxIndex{
//                    self.dismissContoller()
                    self.sendingDataIndex = 0
                }
            })
        }
    }
    
    fileprivate func loadData(topic: String){
        
        if !(topics.contains(topic.lowercased())){
            speak(string: sorrySpeech, rate: 0.55)
            return
        }
        
        let str = "https://newsapi.org/v2/top-headlines?country=us&category=\(topic)&apiKey=b7f7add8d89849be8c82306180dac738"
        homeViewModel.loadNews(str: str) {
            DispatchQueue.main.async {
                self.clearScreen()
                self.endSendingData()
                self.speak(string: "`got it`, sending data to carloudy... you can say: `change topic`, `stop` , or `read` any time.", rate: 0.55)
                GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_optional)
                GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_optional)
                self.createTimer_sendingData()
                
            }
        }
    }
}

extension DrawerViewController: AVSpeechSynthesizerDelegate{
    func speak(string: String, rate: CGFloat = 0.53){
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = Float(rate)
        synthesizer.speak(utterance)
        
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        if utterance.speechString == startSpeech{
            
        }
    }
    
    fileprivate func yuyinxunhuan() {
        animationview.start()
//        carloudySpeech.endMicroPhone()
        carloudySpeech.microphoneTapped()
        timer_forBaseSiri_inNavigationController?.invalidate()
        timer_forBaseSiri_inNavigationController = nil
        timer_forBaseSiri_inNavigationController = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self](_) in
            self?.textReturnedFromSiri = (carloudySpeech.checkText().lowercased())
            ZJPrint(self?.textReturnedFromSiri)
            //let result = self?.textReturnedFromSiri
            guard self?.textReturnedFromSiri.lowercased() != nil else {return}
            if !(carloudySpeech.audioEngine.isRunning){
                carloudySpeech.endMicroPhone()
                carloudySpeech.microphoneTapped()
            }
            // MARK:- 如果这里超过一分钟 audioEngine.isRunning 不工作怎么办？
            if (self?.textReturnedFromSiri.lowercased().contains("change topic"))! || (self?.textReturnedFromSiri.lowercased().contains("change the topic"))! || (self?.textReturnedFromSiri.lowercased().contains("change your topic"))!{
                
                self?.endSendingData()
                self?.endSiriSpeech()
//                GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_choices)
//                GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_choices)
                self?.showImageAlert()
                self?.speak(string: (self?.startSpeech)!)
            }else if (self?.textReturnedFromSiri.lowercased().contains("stop"))! || (self?.textReturnedFromSiri.lowercased().contains("close"))!{
                self?.speak(string: (self?.okcloseSpeech)!, rate: 0.53)
                self?.timer_forBaseSiri_inNavigationController?.invalidate()
                ZJPrint("1111111-------------------------------------------------------------------------------")
                
            }else if (self?.textReturnedFromSiri.lowercased().contains("read the news"))! || (self?.textReturnedFromSiri.lowercased().contains("read"))! ||
                (self?.textReturnedFromSiri.lowercased().contains("read a news"))! || (self?.textReturnedFromSiri.lowercased().contains("read it"))!{
                self?.isStartReadTheNews = true
                //1. 关闭timer
//                self?.timer_forBaseSiri_inNavigationController?.invalidate()
//                self?.timer_forBaseSiri_inNavigationController = nil
//                //2. 关闭录音
//                carloudySpeech.endMicroPhone()
                
                self?.endSiriSpeech()
                //3. 打开read the news
                self?.startReadAndSendTheNews()
                
            }
        })
    }
    
    func clearScreen(){
        CarloudyBLE.shareInstance.sendAppCommand(commandID: "0", appId: carloudyAppStoreAppKey_)
        CarloudyBLE.shareInstance.sendAppCommand(commandID: "0", appId: carloudyAppStoreAppKey_)
    }
    
    func showImageAlert(){
        clearScreen()
        CarloudyBLE.shareInstance.createPictureIDAndImageViewForCarloudyHUD(picID: "ct", postionX: 0, postionY: 0, width: 0, height: 0)
        CarloudyBLE.shareInstance.createPictureIDAndImageViewForCarloudyHUD(picID: "ct", postionX: 0, postionY: 0, width: 0, height: 0)
        self.timer_sendingData = Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: { (_) in
            CarloudyBLE.shareInstance.sendMessage(textViewId: "zzz", message: "")
            CarloudyBLE.shareInstance.createPictureIDAndImageViewForCarloudyHUD(picID: "ct", postionX: 0, postionY: 0, width: 0, height: 0)
            CarloudyBLE.shareInstance.createPictureIDAndImageViewForCarloudyHUD(picID: "ct", postionX: 0, postionY: 0, width: 0, height: 0)
        })
    }
    
    func startReadAndSendTheNews(){
        let articles: [Article] = self.homeViewModel.articles
       // MARK:- Thread 1: Fatal error: Index out of range
        let maxIndex = articles.count
        let article = articles[self.sendingDataIndex]
        self.sendingDataIndex += 1
        if let title = article.title{
            
            sendMessageToCarloudy(title: title)
            if self.isStartReadTheNews == true{
                currentSpeakingNews = title.lowercased()
                self.speak(string: title.lowercased())
                GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_stop)
                return
            }
        }
        if self.sendingDataIndex >= maxIndex{
            self.sendingDataIndex = 0
        }
    }
    
    func waitFewSecondBetweenVoices(){
        //结束说时，打开语音。 给用户两秒时间 停止read
        if let vc = UIApplication.firstViewController() as? LikeViewController{  // && if user choose read
            GloableSiriFunc.shareInstance.startGlobleHeyCarloudyNews(vc: vc)
        }
        
        var timerIndex = 0
        self.timer_checkText = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            timerIndex += 1
            if timerIndex > 3{
                GloableSiriFunc.shareInstance.stopGlobleHeyCarloudyNews()
                self.timer_checkText?.invalidate()
                self.timer_checkText = nil
                if !dataGotFromSiri.contains("stop"){        //停止read
                    self.startReadAndSendTheNews()
                }else{
                    /*
                    GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: "Say 'category' to activate speech")
                    //继续发送？
                    self.isStartReadTheNews = false
                    self.createTimer_sendingData()
//                    self.yuyinxunhuan()
                    */
                    
                    self.speak(string: (self.okcloseSpeech), rate: 0.53)
                }
            }
        }
        //4. 提示用户stop 'read the news'
        //5. 如果用户stop了，进入循环
    }

    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (UIApplication.topViewController() as? LikeViewController) != nil{
            return
        }
        ZJPrint(utterance.speechString)
        if utterance.speechString == okcloseSpeech{
            self.dismissContoller()
        }else if utterance.speechString == startSpeech{
            startSiriSpeech()
            //            animationview.stop()
            
        }else if utterance.speechString.hasPrefix(searchingSpeech){
        }else if utterance.speechString == closeSpeech{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                //                self.endSiriSpeech()
                self.dismissContoller()
            }
        }else if utterance.speechString == sorrySpeech{
            speak(string: startSpeech)
        }else if utterance.speechString.hasPrefix("`got it`, sending data to carloudy"){
            yuyinxunhuan()
            
        }else if utterance.speechString.lowercased() == currentSpeakingNews && isStartReadTheNews{
            self.waitFewSecondBetweenVoices()
        }
    }
}

extension DrawerViewController: GloableSiriFuncDelegate{
    func gloableSiriFuncOpenCarloudyNewsWasSaid() {
    }
    
    func gloableSiriFuncTextReturn(text: String) {
        dataGotFromSiri = text
    }
}
