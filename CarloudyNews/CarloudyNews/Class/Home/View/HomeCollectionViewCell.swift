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
            if let author = article.author, let source = article.source, let name = source.name{
                newsAuther.text = author + " | " + name
            }
            title.text = article.title ?? ""
            time.text = article.publishedAt ?? ""
            if let imageUrl = article.urlToImage{
               imageView.loadImage(urlString: imageUrl)
            }
            descriptionLabel.text = article.description
//            ZJPrint(article.content)
            
        }
    }

    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newsAuther: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var newsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
//        frame.size.width = zjScreenWidth
        imageViewHeight.constant = zjScreenWidth/1.778
    }
    
    
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var frame = layoutAttributes.frame
//        frame.size.height = ceil(size.height)
//        layoutAttributes.frame = frame
//        ZJPrint(self.frame.size.width)
//        return layoutAttributes
//    }
    
}
