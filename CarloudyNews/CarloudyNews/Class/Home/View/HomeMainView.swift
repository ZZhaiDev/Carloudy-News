//
//  HomeCollectionView.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit


fileprivate let basiCellId = "basiCellId"
fileprivate let secondCellId = "secondCellId"
var isBasicCell_ = false
//fileprivate let cellHeight: CGFloat = 400.0

public protocol HomeMainViewDelegate{
    func homeMainView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class HomeMainView: UIView {
    
    open var delegate : HomeMainViewDelegate?
    
    var articles = [Article](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        
//        layout.itemSize.width = zjScreenWidth
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
//        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: basiCellId)
        cv.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: secondCellId)

        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HomeMainView{
    fileprivate func setupUI(){
        self.addSubview(collectionView)
        collectionView.frame = self.bounds
    }
}


extension HomeMainView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return min(10, articles.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        isBasicCell_ = true
        if indexPath.item % 2 == 0{
            isBasicCell_ = false
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCellId, for: indexPath) as! SecondCollectionViewCell
            let article = articles[indexPath.item]
            cell.cellData = article
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: basiCellId, for: indexPath) as! HomeCollectionViewCell
            let article = articles[indexPath.item]
            cell.cellData = article
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeMainView(collectionView, didSelectItemAt: indexPath)
    }

//    MARK: -- 计算cell高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.item % 2 == 0{
            isBasicCell_ = false
        }else{
            isBasicCell_ = true
        }
        
        if isBasicCell_ == false{
            let cellWidth = zjScreenWidth - 40
            return CGSize(width: cellWidth, height: zjCollectionViewCell + 35)
//            return CGSize(width: cellWidth, height: 400 + 35)
            

        }else{
            let approximateWidthOfContent = self.frame.width - 40

            let size = CGSize(width: approximateWidthOfContent, height: 1000)

            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            let article = articles[indexPath.item]
            if let text = article.description{
                let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height = estimatedFrame.height + 135 + zjScreenWidth/1.778 + 10
                ZJPrint(text)
                ZJPrint(height)
                return CGSize(width: zjScreenWidth - 40, height: height)

            }
            return CGSize(width: zjScreenWidth - 40, height: 135 + zjScreenWidth/1.778)
        }
    }
    
}

