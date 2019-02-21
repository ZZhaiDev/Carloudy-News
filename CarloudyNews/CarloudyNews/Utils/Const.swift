//
//  Const.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS





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

func sendMessageToCarloudy(title: String, content: String = ""){
    let carloudyBLE = CarloudyBLE.shareInstance
    if let pairkey = carloudyBlePairKey_{
        carloudyBLE.newKeySendToPairAndorid_ = pairkey
    }
    carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
    carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "3", labelTextSize: 25, postionX: 10, postionY: 10, width: 80, height: 60)
    carloudyBLE.sendMessage(textViewId: "3", message: title)
    
    if content != ""{
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "4", labelTextSize: 25, postionX: 10, postionY: 40, width: 80, height: 00)
        carloudyBLE.sendMessage(textViewId: "4", message: content)
    }
}
