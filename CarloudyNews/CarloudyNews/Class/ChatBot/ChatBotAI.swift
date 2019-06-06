//
//  ChatBotAI.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 6/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ChatBotAI: NSObject{
    let request = ApiAI.shared().textRequest()
    let speechSynthesizer = AVSpeechSynthesizer()
}


extension ChatBotAI{
    func sendMessage(message: String, finished: @escaping (String)->()){
        
        request?.query = message
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
//            if let textResponse = response.result.fulfillment.speech {
//                self.speechAndText(text: textResponse)
//            }
            finished(response.result.fulfillment.speech)
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
}

