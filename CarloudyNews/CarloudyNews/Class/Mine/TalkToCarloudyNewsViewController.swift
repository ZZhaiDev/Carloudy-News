//
//  TalkToCarloudyNewsViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 2/27/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

var isEnableOpenCarloudyNews = false{
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

class TalkToCarloudyNewsViewController: UIViewController {
    
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBAction func switchButtonClicked(_ sender: Any) {
        if switchButton.isOn{
            isEnableOpenCarloudyNews = true
        }else{
            isEnableOpenCarloudyNews = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchButton.setOn(isEnableOpenCarloudyNews, animated: false)
        self.view.backgroundColor = UIColor.background
        self.title = "Speech Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        switchButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    

}
