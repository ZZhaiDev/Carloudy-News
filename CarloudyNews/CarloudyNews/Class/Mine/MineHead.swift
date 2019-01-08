//
//  MineHead.swift
//  Carloudy-Weather
//
//  Created by zijia on 12/13/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit

class MineHead: UIView {
    
    lazy var bgView: UIImageView = {
        let bw = UIImageView()
        bw.contentMode = .scaleAspectFill
        bw.image = UIImage(named: "mine_bg_for_boy")
        return bw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI(){
        addSubview(bgView)
        bgView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
