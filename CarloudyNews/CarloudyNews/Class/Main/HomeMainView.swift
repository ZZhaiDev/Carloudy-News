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

//fileprivate let cellHeight: CGFloat = 400.0

public protocol HomeMainViewDelegate{
    func homeMainView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func homeMainViewSecondCollectionViewCell(title: String, description: String, name: String)
}

class HomeMainView: UIView {
    
    fileprivate var startOffsetY : CGFloat = settingViewHeight + zjStatusHeight + 5
    fileprivate var conteninsetY: CGFloat = settingViewHeight + zjStatusHeight + 5
    open var delegate : HomeMainViewDelegate?
    var isdefaultTheme = true
    
    var articles = [Article](){
        didSet{
            collectionView.reloadData()
        }
    }
    
//    let settingView: SettingView = {
//        let view = SettingView.settingView()
//        view.backgroundColor = .clear
//        return view
//    }()
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: basiCellId)
        cv.register(SecondCollectionViewCell.self, forCellWithReuseIdentifier: secondCellId)
        var contentY = conteninsetY
        if isdefaultTheme == true{
            contentY = 8
        }
        cv.contentInset = UIEdgeInsets(top: contentY, left: 0, bottom: 200, right: 0)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
     init(frame: CGRect, isdefaultTheme: Bool = false) {
        super.init(frame: frame)
        self.isdefaultTheme = isdefaultTheme
//        self.layer.cornerRadius  = 50
//        self.layer.masksToBounds = true
        
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
//        self.scrollViewDidScroll(collectionView)
//        self.addSubview(settingView)
//        settingView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: settingViewHeight)
    }
}


extension HomeMainView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return min(20, articles.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if cellStyle_ == cellStyleSegmentedControl_Array[0]{
            if indexPath.item % 2 == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCellId, for: indexPath) as! SecondCollectionViewCell
                cell.delegate = self
                cell.index = indexPath.item
                let article = articles[indexPath.item]
                cell.cellData = article
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: basiCellId, for: indexPath) as! HomeCollectionViewCell
                let article = articles[indexPath.item]
                cell.cellData = article
                return cell
            }
        }else if cellStyle_ == cellStyleSegmentedControl_Array[1]{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: basiCellId, for: indexPath) as! HomeCollectionViewCell
            let article = articles[indexPath.item]
            cell.cellData = article
            return cell
        }
        //  if cellStyle_ == cellStyleSegmentedControl_Array[2]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCellId, for: indexPath) as! SecondCollectionViewCell
        cell.delegate = self
        cell.index = indexPath.item
        let article = articles[indexPath.item]
        cell.cellData = article
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeMainView(collectionView, didSelectItemAt: indexPath)
    }

//    MARK: -- 计算cell高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if cellStyle_ == cellStyleSegmentedControl_Array[0]{
            if indexPath.item % 2 == 0{
                let cellWidth = zjScreenWidth - 40
                return CGSize(width: cellWidth, height: zjCollectionViewCell + 35)
            }else{
                let approximateWidthOfContent = self.frame.width - 40
                
                let size = CGSize(width: approximateWidthOfContent, height: 1000)
                
                let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
                let article = articles[indexPath.item]
                if let text = article.description{
                    let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                    let height = estimatedFrame.height + 135 + zjScreenWidth/1.778 + 10
                    //                ZJPrint(text)
                    //                ZJPrint(height)
                    return CGSize(width: zjScreenWidth - 40, height: height)
                    
                }
                return CGSize(width: zjScreenWidth - 40, height: 135 + zjScreenWidth/1.778)
            }
        }else if cellStyle_ == cellStyleSegmentedControl_Array[1]{
            let approximateWidthOfContent = self.frame.width - 40
            
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            let article = articles[indexPath.item]
            if let text = article.description{
                let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height = estimatedFrame.height + 135 + zjScreenWidth/1.778 + 10
                //                ZJPrint(text)
                //                ZJPrint(height)
                return CGSize(width: zjScreenWidth - 40, height: height)
                
            }
            return CGSize(width: zjScreenWidth - 40, height: 135 + zjScreenWidth/1.778)
        }
        
        let cellWidth = zjScreenWidth - 40
        return CGSize(width: cellWidth, height: zjCollectionViewCell + 35)
    }
    
}


// MARK:-- ScrollDelegate
extension HomeMainView{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeSettingViewAlphaWhileScrolling(offsetY: scrollView.contentOffset.y)
    }
    
    func changeSettingViewAlphaWhileScrolling(offsetY: CGFloat){
        if let topViewController = UIApplication.topViewController() as? LikeViewController{
            if offsetY > startOffsetY{
                if  offsetY > -158 && offsetY < -zjNavigationBarHeight{
                    topViewController.settingView.alpha = 1 - (conteninsetY + offsetY) * (1/(conteninsetY - zjNavigationBarHeight))
                    ZJPrint(topViewController.settingView.alpha)
                    ZJPrint("up")
                }else if offsetY > 0{
                    topViewController.settingView.alpha = 0
                }
            }else{
                if  offsetY > -158 && offsetY < -zjNavigationBarHeight{
                    topViewController.settingView.alpha = 1 - (conteninsetY + offsetY) * (1/(conteninsetY - zjNavigationBarHeight))
                }else if offsetY < -158{
                    topViewController.settingView.alpha = 1
                }
            }
            
        }
    }
}


extension HomeMainView: SecondCollectionViewCellDelegate{
    func secondCollectionViewCell(title: String, description: String, name: String) {
        delegate?.homeMainViewSecondCollectionViewCell(title: title, description: description, name: name)
    }
}

