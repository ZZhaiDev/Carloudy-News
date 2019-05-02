//
//  SiriViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 4/10/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS
import AVFoundation

class SiriViewController: UIViewController {
    var dataIndex = 0
    var dataGotFromSiri = ""
    var currentSpeakingNews = ""
    lazy var homeViewModel = HomeViewModel()
    //    fileprivate weak var tempTimer: Timer?
    weak var timer_checkText: Timer?
    func invalidatetimer_checkText(){
        if timer_checkText != nil{
            timer_checkText?.invalidate()
            timer_checkText = nil
        }
    }
    
    var timer_sendingData_home: Timer?
    func invalidatetimer_sendingData_home(){
        if timer_sendingData_home != nil{
            timer_sendingData_home?.invalidate()
            timer_sendingData_home = nil
        }
    }
    
    lazy var synthesizer : AVSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        return synthesizer
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GloableSiriFunc.shareInstance.delegate = self
    }
    
    func checkIfContainsReadNews(str: String) -> Bool{
        if (str.lowercased().contains("read the news")) || (str.lowercased().contains("read news")) ||
            (str.lowercased().contains("read a news")) || (str.lowercased().contains("read it")){
            return true
        }
        return false
    }
    
    func startGlobleHeyCarloudyNews(){
        if let vc = UIApplication.firstViewController() as? LikeViewController{  // && if user choose read
            GloableSiriFunc.shareInstance.startGlobleHeyCarloudyNews(vc: vc)
        }
    }
    
    
    func checkReadNews(_ articles: [Article], _ maxIndex: Int) {
        // 检查read news
        invalidatetimer_checkText()
        //                    self.startGlobleHeyCarloudyNews()
        timer_checkText = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { (_) in
            ZJPrint(self.dataGotFromSiri)
            if self.checkIfContainsReadNews(str: self.dataGotFromSiri){
                self.invalidatetimer_sendingData_home()
                self.invalidatetimer_checkText()
                GloableSiriFunc.shareInstance.stopGlobleHeyCarloudyNews()
                // sendmessage and speak
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.sendMessageWithNoTimer(articles: articles, maxIndex: maxIndex)
                })
            }
        })
    }
    
    func sendMessageWithNoTimer(articles: [Article], maxIndex: Int){
        let article = articles[dataIndex]
        if let title = article.title{
            self.speak(string: title)
            GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_stop)
            currentSpeakingNews = title
            sendMessageToCarloudy(title: title)
        }
        dataIndex += 1
        if dataIndex >= maxIndex{
            dataIndex = 0
        }
    }
    
    func sendMessageWithTimer(articles: [Article], maxIndex: Int){
        
        if timer_sendingData_home == nil{
            timer_sendingData_home?.invalidate()
            let article = articles[dataIndex]
            if let title = article.title{
                sendMessageToCarloudy(title: title)
            }
            timer_sendingData_home = Timer.scheduledTimer(withTimeInterval: TimeInterval(8), repeats: true, block: { (_) in
                let article = articles[self.dataIndex]
                if let title = article.title{
                    //                    self.speak(string: title)
                    sendMessageToCarloudy(title: title)
                    GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_openCarloudyNewsOrReadNews)
                }
                self.dataIndex += 1
                if self.dataIndex >= maxIndex{
                    //                    self.timer_sendingData_home?.invalidate()
                    //                    self.timer_sendingData_home = nil
                    self.dataIndex = 0
                }
            })
            
        }
    }
}

extension SiriViewController: AVSpeechSynthesizerDelegate, GloableSiriFuncDelegate{
    func speak(string: String, rate: CGFloat = 0.53){
        //开始说时 关闭recording
        GloableSiriFunc.shareInstance.stopGlobleHeyCarloudyNews()
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = Float(rate)
        synthesizer.speak(utterance)
        
    }
    
    func checkWhatUserSaidBetweenTwoVoices() {
        //结束说时，打开语音。 给用户两秒时间 停止read
        self.startGlobleHeyCarloudyNews()
        
        invalidatetimer_checkText()
        let articles = self.homeViewModel.articles
        let maxIndex = articles.count
        
        var timerIndex = 0
        timer_checkText = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            timerIndex += 1
            
            if timerIndex > 3{
                self.timer_checkText?.invalidate()
                self.timer_checkText = nil
                if !self.dataGotFromSiri.contains("stop"){        //停止read
                    GloableSiriFunc.shareInstance.stopGlobleHeyCarloudyNews()
                    
                    self.sendMessageWithNoTimer(articles: articles, maxIndex: maxIndex)
                }else{
                    GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: carloudy_show_openCarloudyNewsOrReadNews)
                    self.sendMessageWithTimer(articles: articles, maxIndex: maxIndex)
                    self.checkReadNews(articles, maxIndex)
                }
            }
            ZJPrint(timerIndex)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        ZJPrint(utterance.speechString.lowercased())
//        ZJPrint(currentSpeakingNews.lowercased())
//        if utterance.speechString.lowercased() == currentSpeakingNews.lowercased(){
//            if isListenForReadNews == 1{
//                self.checkWhatUserSaidBetweenTwoVoices()
//            }else if isListenForReadNews == 2{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    let articles = self.homeViewModel.articles
//                    let maxIndex = articles.count
//                    self.sendMessageWithNoTimer(articles: articles, maxIndex: maxIndex)
//                }
//            }
//            
//        }
//        switch isListenForReadNews {
//        case 0:
//            break
//        case 1:
//            break
//        case 2:
//            break
//        default:
//            break
//        }
        
        
    }
    
    
    @objc func gloableSiriFuncTextReturn(text: String) {
//        dataGotFromSiri = text
    }
    @objc func gloableSiriFuncOpenCarloudyNewsWasSaid() {
//        invalidatetimer_sendingData_home()
//        invalidatetimer_checkText()
    }
}
