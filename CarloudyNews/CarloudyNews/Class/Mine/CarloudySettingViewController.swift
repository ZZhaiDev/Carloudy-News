//
//  CarloudySettingViewController.swift
//  CarloudyWeather
//
//  Created by Zijia Zhai on 12/19/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS

class CarloudySettingViewController: UIViewController {
    
    let carloudyBLE = CarloudyBLE.shareInstance
    
    let scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.contentSize = CGSize(width: zjScreenWidth, height: 600)
        return sv
    }()
    
    let textLabel: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = "1. Pair your Carloudy App and Carloudy HUD\n\n2. Open Carloudy-News app by Carloudy App\n\nStep1 & Step2 will give Carloudy-Weather app the pair key, you only need to do them once if you do not change the pair key\n\n3. Send your WIFi to Carloudy HUD:"
        tl.font = UIFont.boldSystemFont(ofSize: 15)
        tl.textColor = .black
        return tl
    }()
    
    lazy var sendButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.5
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Send Wifi", for: .normal)
        button.addTarget(self, action: #selector(updateButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let textLabel2: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = "4. Check your Carloudy HUD, after you see WIFI Connected Successfully, you can update images to Carloudy"
        tl.font = UIFont.boldSystemFont(ofSize: 15)
        tl.textColor = .black
        return tl
    }()
    
    let textLabel3: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = "5. Check your Carloudy HUD, after you see Image Download Successfully, you can see the image when you open the app next time."
        tl.font = UIFont.boldSystemFont(ofSize: 15)
        tl.textColor = .black
        return tl
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.5
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Update Images", for: .normal)
        button.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        if let pairkey = carloudyBlePairKey_{
            carloudyBLE.newKeySendToPairAndorid_ = pairkey
        }
    }
    
    
    fileprivate func setupUI(){
        
        self.title = "Update Images"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.scrollView.backgroundColor = UIColor.background
        self.view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.scrollView.addSubview(textLabel)
        textLabel.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 0)
        self.scrollView.addSubview(sendButton)
        sendButton.anchor(top: textLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 50)
        self.scrollView.addSubview(textLabel2)
        textLabel2.anchor(top: sendButton.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 0)
        self.scrollView.addSubview(downloadButton)
        downloadButton.anchor(top: textLabel2.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 50)
        self.scrollView.addSubview(textLabel3)
        textLabel3.anchor(top: downloadButton.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 0)
    }
    
    @objc func updateButtonClicked(){
        
        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
        carloudyBLE.alertViewToUpdateImagesFromServer()
        ZJPrint(carloudyBLE)
    }
    
    @objc fileprivate func downloadButtonClicked(){
        //startANewSession also let Carloudy HUD download the images
        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
        self.downloadButton.isEnabled = false
        self.downloadButton.backgroundColor = UIColor.lightGray
        self.downloadButton.setTitle("Sent, check your carloudy", for: .normal)
        self.downloadButton.setTitleColor(.black, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.downloadButton.isEnabled = true
            self.downloadButton.backgroundColor = .blue
            self.downloadButton.alpha = 0.5
            self.downloadButton.setTitle("Update Images", for: .normal)
            self.downloadButton.setTitleColor(.white, for: .normal)
        }
    }

   

}
