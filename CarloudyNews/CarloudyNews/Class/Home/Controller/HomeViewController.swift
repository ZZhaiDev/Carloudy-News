//
//  HomeViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS
let ZJTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    
    
    var childVcs = [UIViewController]()
    fileprivate let titles = [NewsSubCat.business.description, NewsSubCat.entertainment.description, NewsSubCat.health.description, NewsSubCat.science.description, NewsSubCat.sports.description, NewsSubCat.technology.description]
//    private lazy var navigationMaxY: CGFloat = (navigationController?.navigationBar.frame.maxY) ?? 88
    fileprivate lazy var pageTitleView : PageTitleView = {[unowned self] in
        let y = zjStatusHeight + zjNavigationBarHeight
        let titleFrame = CGRect(x: 0, y: y, width: zjScreenWidth, height: ZJTitleViewH)
        let titles = self.titles
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView : ContentMainView = {[weak self] in
        
        // 1.确定内容的frame
        let y = zjStatusHeight + zjNavigationBarHeight + ZJTitleViewH
        ZJPrint(y)
        let contentH = zjScreenHeight - zjStatusHeight - zjNavigationBarHeight - ZJTitleViewH - zjTabBarHeight
        let contentFrame = CGRect(x: 0, y: y, width: zjScreenWidth, height: contentH)
        
        // 2.确定所有的子控制器
//        addControllers(cat: NewsCat.everything.description, subCat: titles[0])
//        addControllers(cat: NewsCat.everything.description, subCat: titles[1])
        for title in titles{
//            ZJPrint(title)
            addControllers(cat: NewsCat.topheadlines.description, subCat: title)
        }
        
        let contentView = ContentMainView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    fileprivate func addControllers(cat: String, subCat: String){
        let vc = AllViewController(cat: cat, subCat: subCat)
        childVcs.append(vc)
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
//        ZJPrint(index)
        pageContentView.setCurrentIndex(index)
    }
}


// MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController : ContentMainViewDelegate {
    func pageContentView(_ contentView: ContentMainView, progress: CGFloat, sourceIndex: Int, targetIndex: Int, direction_left: Bool) {
//        ZJPrint("sourceIndex-\(sourceIndex)-\(targetIndex)")
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex, direction_left: direction_left)
    }
    
}






