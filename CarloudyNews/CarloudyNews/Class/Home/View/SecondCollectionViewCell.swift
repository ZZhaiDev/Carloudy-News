//
//  SecondCollectionViewCell.swift
//  CarloudyNews
//
//  Created by zijia on 1/5/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

public protocol SecondCollectionViewCellDelegate: class{
    func secondCollectionViewCell(title: String, description: String, name: String)
}

class SecondCollectionViewCell: UICollectionViewCell {
    
    var index = 2
    weak var delegate: SecondCollectionViewCellDelegate?
    
    var cellData: Article?{
        didSet{
            guard let article = cellData else{ return }
            if let author = article.author, let source = article.source, let name = source.name{
                nameLabel.text = author + " | " + name + "  "
            }
            titleLabel.text = article.title ?? ""
            timeLabel.text = article.publishedAt ?? ""
            if let imageUrl = article.urlToImage{
                imageV.loadImage(urlString: imageUrl)
            }
            if index == 0{
                delegate?.secondCollectionViewCell(title: titleLabel.text ?? "", description: article.description ?? "", name: nameLabel.text ?? "")
            }
            
        }
    }
    
    let nameLabel : PaddingLabel = {
       let label = PaddingLabel()
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
//        label.alpha = 0.5
        return label
    }()
    
    
    
    
    
    let imageV: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//            iv.contentMode = .center
        
        return iv
    }()
    
    let timeLabel : PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let titleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        return view
    }()
    
    let bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let bottomLabel: UILabel = {
       let label = UILabel()
        label.text = "View full Coverage"
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return label
    }()
    
    lazy var sendDataButton: UIButton = {[weak self] in
        let button = UIButton()
        button.setTitle("  send data to Carloudy  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.alpha = 0.6
//        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        button.layer.masksToBounds = true
        button.addTarget(self!, action: #selector(sendButtonclicked), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    @objc fileprivate func sendButtonclicked(){
        sendDataButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sendDataButton.isHidden = false
        }
        sendMessageToCarloudy(title: titleLabel.text ?? "")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
//        let cellWidth = zjScreenWidth - 40
//        let imageHeight = cellWidth/1.778
        
        self.addSubview(imageV)
        imageV.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: zjCollectionViewCell)
        
        imageV.addSubview(nameLabel)
        nameLabel.anchor(top: imageV.topAnchor, left: nil, bottom: nil, right: imageV.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        
        imageV.addSubview(titleBackgroundView)
        titleBackgroundView.anchor(top: nil, left: imageV.leftAnchor, bottom: imageV.bottomAnchor, right: imageV.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 65)
        
        imageV.addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: imageV.leftAnchor, bottom: imageV.bottomAnchor, right: imageV.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 15, paddingRight: 10, width: 0, height: 46)
        
        imageV.addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: imageV.leftAnchor, bottom: titleLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(bottomView)
        bottomView.anchor(top: imageV.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        bottomView.addSubview(bottomLabel)
        bottomLabel.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, bottom: bottomView.bottomAnchor, right: bottomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(sendDataButton)
        sendDataButton.anchor(top: bottomView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        
//       addParallaxToView(vw: imageV)
        
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
