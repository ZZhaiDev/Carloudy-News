//
//  HomeCollectionViewCell.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    var cellData: Article?{
        didSet{
            guard let article = cellData else{ return }
            newsAuther.text = article.author ?? ""
            title.text = article.title ?? ""
            time.text = article.publishedAt ?? ""
            if let imageUrl = article.urlToImage{
               imageView.loadImage(urlString: imageUrl)
            }
            
        }
    }

    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newsAuther: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var newsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        imageViewHeight.constant = zjScreenWidth/1.778
    }
    
}
