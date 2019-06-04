//
//  ChatBotViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 6/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ChatBotViewController: UIViewController {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var resultL: UILabel!
    @IBOutlet weak var sendTextF: UITextField!
    @IBOutlet weak var sendB: UIButton!
    @IBAction func sendButtonClicked(_ sender: Any) {
        guard let text = sendTextF.text else {return}
        sendMessage(message: text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopGlobleHeyCarloudyNews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        startGlobleHeyCarloudyNews(vc: <#T##UIViewController#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func sendMessage(message: String){
        let request = ApiAI.shared().textRequest()
        request?.query = message
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        sendTextF.text = ""
        resultL.text = text
    }

}
