//
//  HomeCollectionView.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit


fileprivate let cellId = "cellId"
//fileprivate let cellHeight: CGFloat = 300.0

class HomeMainView: UIView {
    var articles = [Article](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize.width = zjScreenWidth
        layout.itemSize.height = 400
        
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
//        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
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


extension HomeMainView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return min(5, articles.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCollectionViewCell
        cell.cellData = articles[indexPath.item]
        return cell
    }
    
    
}

