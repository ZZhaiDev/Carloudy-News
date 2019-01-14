//
//  Const.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit





//Commons
let zjScreenWidth: CGFloat = UIScreen.main.bounds.width
let zjScreenHeight: CGFloat = UIScreen.main.bounds.height
let zjTitlePageWidth: CGFloat = zjScreenWidth - 80


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
