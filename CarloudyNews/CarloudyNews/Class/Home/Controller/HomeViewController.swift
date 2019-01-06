//
//  HomeViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let ZJTitleViewH : CGFloat = 40
    
    
    private lazy var navigationMaxY: CGFloat = (navigationController?.navigationBar.frame.maxY) ?? 88
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: navigationMaxY, width: zjScreenWidth, height: ZJTitleViewH)
        let titles = ["bit", "everything", "娱乐", "趣玩", "推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView : ContentMainView = {[weak self] in
        
        // 1.确定内容的frame
        let contentH = zjScreenHeight - ZJTitleViewH - 88
        let contentFrame = CGRect(x: 0, y: ZJTitleViewH + 88, width: zjScreenWidth, height: contentH)
        
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        let bit = AllViewController()
        childVcs.append(bit)
        let apple = AllViewController()
        apple.parameters = "apple"
        childVcs.append(apple)
        let us = AllViewController()
        us.parameters = "us"
        childVcs.append(us)
        childVcs.append(AllViewController())
        
        let contentView = ContentMainView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    
    
    override func loadView() {
        super.loadView()
//        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}


// MARK:- ui
extension HomeViewController{
    fileprivate func setupUI(){
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        setupNavigationBar()
    }
    
    fileprivate func setupNavigationBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "Carloudy_logo")
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}


// MARK:- 遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}


// MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController : ContentMainViewDelegate {
    func pageContentView(_ contentView: ContentMainView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}






