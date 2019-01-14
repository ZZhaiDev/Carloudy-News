//
//  LikeViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
var settingViewHeight: CGFloat = 108

class LikeViewController: UIViewController {
    
    var highlightedButton: UIButton?
    
    
    fileprivate let maintitles =  ["U.S.", "Chicago", "World"]
    var childVcs = [UIViewController]()
    
    //    private lazy var navigationMaxY: CGFloat = (navigationController?.navigationBar.frame.maxY) ?? 88
    fileprivate lazy var pageTitleView : PageTitleView = {[unowned self] in
        let y = zjStatusHeight + zjNavigationBarHeight
        let titleFrame = CGRect(x: 0, y: 0, width: zjTitlePageWidth, height: ZJTitleViewH)
        let titles = self.maintitles
        let titleView = PageTitleView(frame: titleFrame, titles: titles, isEnableBottomLine: false, defaultTheme: false)
//        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        titleView.backgroundColor = .red
        return titleView
    }()
    
    let settingView: SettingView = {
        let view = SettingView.settingView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var pageContentView : ContentMainView = {[weak self] in
//        let y =  100
//        ZJPrint(y)
        let contentH = zjScreenHeight - zjTabBarHeight
        let contentFrame = CGRect(x: 0, y: 0, width: zjScreenWidth, height: contentH)
        for title in maintitles{
            addControllers(cat: NewsCat.everything.description, subCat: title)
        }
        let contentView = ContentMainView(frame: contentFrame, childVcs: childVcs, parentViewController: self, isdefaultTheme: false)
        contentView.delegate = self
        
//        contentView.backgroundColor = .yellow
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



extension LikeViewController{
    fileprivate func setupUI(){
        setupNavigationBar()
//        self.view.backgroundColor = .clear
//        view.addSubview(settingView)
//        settingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: settingViewHeight)
        
//        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        pageContentView.addSubview(settingView)
        settingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: settingViewHeight)
    }
    
    fileprivate func setupNavigationBar(){
       // navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationItem.titleView = pageTitleView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageTitleView)
//        pageTitleView.backgroundColor = .red
        let size = CGSize(width: 40, height: 40)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        navigationItem.rightBarButtonItem = searchItem
    }
    
    fileprivate func addNavigationItem(buttonTitle: String, size: CGSize, tag: Int) -> UIBarButtonItem{
        let btn = UIButton()
        if tag == 0{
            btn.isSelected = true
            highlightedButton = btn
        }
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.tag = tag
        btn.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        btn.setTitle(buttonTitle, for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(.black, for: .selected)
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        return UIBarButtonItem(customView: btn)
    }
    
    @objc func buttonClicked(sender: UIButton){
        highlightedButton?.isSelected = false
        sender.isSelected = true
        highlightedButton = sender
    }
}


extension LikeViewController{
    
}


// MARK:- 遵守PageTitleViewDelegate协议
extension LikeViewController : PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        //        ZJPrint(index)
        pageContentView.setCurrentIndex(index)
    }
}


// MARK:- 遵守PageContentViewDelegate协议
extension LikeViewController : ContentMainViewDelegate {
    func pageContentView(_ contentView: ContentMainView, progress: CGFloat, sourceIndex: Int, targetIndex: Int, direction_left: Bool) {
        //        ZJPrint("sourceIndex-\(sourceIndex)-\(targetIndex)")
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex, direction_left: direction_left)
    }
    
}
