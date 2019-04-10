//
//  TalkToCarloudyNewsViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 2/27/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

var isEnableOpenCarloudyNews = true{
    didSet{
        UserDefaults.standard.set(isEnableOpenCarloudyNews, forKey: "isEnableOpenCarloudyNews")
        if isEnableOpenCarloudyNews{
            if let vc = UIApplication.firstViewController() as? LikeViewController{
                startGlobleHeyCarloudyNews(vc: vc)
            }
        }else{
            stopGlobleHeyCarloudyNews(stopOnce: true)
        }
    }
}

/**
 * 0 means never
 * 1 means 用户控制
 * 2 means always
 **/
var isListenForReadNews: Int = 1{
    didSet{
        UserDefaults.standard.set(isListenForReadNews, forKey: "isListenForReadNews")
    }
}



class TalkToCarloudyNewsViewController: UIViewController {
    @IBOutlet weak var switchButton: UISwitch!
    @IBAction func switchButtonClicked(_ sender: Any) {
        if switchButton.isOn{
            isEnableOpenCarloudyNews = true
        }else{
            isEnableOpenCarloudyNews = false
        }
    }
    @IBOutlet weak var listenForReadNews: UISegmentedControl!
    @IBAction func listenForReadNewsClicked(_ sender: Any) {
        switch listenForReadNews.selectedSegmentIndex{
        case 0:
            isListenForReadNews = 0
        case 1:
            isListenForReadNews = 1
        case 2:
            isListenForReadNews = 2
        default:
            isListenForReadNews = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchButton.setOn(isEnableOpenCarloudyNews, animated: false)
        listenForReadNews.selectedSegmentIndex = isListenForReadNews
        
        self.view.backgroundColor = UIColor.background
        self.title = "Speech Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    

}
