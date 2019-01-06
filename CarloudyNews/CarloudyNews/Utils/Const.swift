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

let zjCollectionViewCell: CGFloat = 300


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
