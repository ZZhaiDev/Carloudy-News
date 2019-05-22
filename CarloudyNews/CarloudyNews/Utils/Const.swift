//
//  Const.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS

let carloudySpeech = CarloudySpeech()
weak var globleTimer: Timer?

//Commons
let zjScreenWidth: CGFloat = UIScreen.main.bounds.width
let zjScreenHeight: CGFloat = UIScreen.main.bounds.height
let zjTitlePageWidth: CGFloat = zjScreenWidth - 120

var isEditingSettingView: Bool = false{
    didSet{
        settingViewHeight = isEditingSettingView ? 158 : 108
    }
}
var settingViewHeight: CGFloat =  108


// 判断是否为 iPhone X
let isIphoneX = zjScreenHeight >= 812 ? true : false
// 状态栏高度
let zjStatusHeight : CGFloat = isIphoneX ? 44 : 20
// 导航栏高度
let zjNavigationBarHeight :CGFloat = 44
// TabBar高度
let zjTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49

let zjCollectionViewCell: CGFloat = 300

var carloudyBlePairKey_: String?
var carloudyAppStoreAppKey_: String = "4bae9gb4"
var launchAppByCarloudyNotificationKey_ = "launchAppByCarloudyNotificationKey"
var settingViewUpdateAndReloadDataNotificationKey_ = "settingViewUpdateAndReloadDataNotificationKey"




func getloadingImages() -> [UIImage] {
    var loadingImages = [UIImage]()
    for index in 0...14 {
        let loadImageName = String(format: "dyla_img_loading_%03d", index)
        if let loadImage = UIImage(named: loadImageName) {
            loadingImages.append(loadImage)
        }
    }
    return loadingImages
}

/*
 x (2) [00-90]: position-x for display section
 y (2) [00-72]: position-y for display section
 width (2) [01-90]: width for display section; “00” for auto fit width
 height (2) [01-72]: height for display section; “00” for auto fit height
 */


func sendMessageToCarloudy(title: String, content: String = ""){
    GloableSiriFunc.shareInstance.sendMessageToCarloudy(title: title, content: content)
}

func startGlobleHeyCarloudyNews(vc: UIViewController){
    GloableSiriFunc.shareInstance.startGlobleHeyCarloudyNews(vc: vc)
    
}

func stopGlobleHeyCarloudyNews(stopOnce: Bool = false){
    GloableSiriFunc.shareInstance.stopGlobleHeyCarloudyNews(stopOnce: stopOnce)
}


let carloudy_show_openCarloudyNewsOrReadNews = "'category','read','open carloudy'"
let carloudy_show_stop = "Say 'Stop' between two voices to cancel"
let carloudy_show_choices = "Say business, entertainment, health, science.."
let carloudy_show_optional = "Say 'change topic', 'Stop' or 'read'"

