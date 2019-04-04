//
//  LikeViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS


let titles_StringDescription = "titles_"

class LikeViewController: UIViewController {
    
    var highlightedButton: UIButton?
    
    
    var maintitles =  ["U.S.", "Chicago", "World"]{
        didSet{
            UserDefaults.standard.set(maintitles, forKey: titles_StringDescription)
            
            pageTitleView.titles = maintitles
            childVcs.removeAll()
            for title in maintitles{
                addControllers(cat: NewsCat.everything.description, subCat: title)
            }
            pageContentView.childVcs = self.childVcs
        }
    }
    var childVcs = [UIViewController]()
    
    lazy var pageTitleView : PageTitleView = {[unowned self] in
        let y = zjStatusHeight + zjNavigationBarHeight
        let titleFrame = CGRect(x: 0, y: 0, width: zjTitlePageWidth, height: ZJTitleViewH)
        let titles = self.maintitles
        let titleView = PageTitleView(frame: titleFrame, titles: titles, isEnableBottomLine: false, defaultTheme: false)
        titleView.delegate = self
        return titleView
    }()
    
    let settingView: SettingView = {
        let view = SettingView.settingView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var pageContentView : ContentMainView = {[weak self] in
        let contentH = zjScreenHeight - zjTabBarHeight
        let contentFrame = CGRect(x: 0, y: 0, width: zjScreenWidth, height: contentH)
        for title in maintitles{
            addControllers(cat: NewsCat.everything.description, subCat: title)
        }
        let contentView = ContentMainView(frame: contentFrame, childVcs: childVcs, parentViewController: self, isdefaultTheme: false)
        contentView.delegate = self
        return contentView
    }()
    
    fileprivate func addControllers(cat: String, subCat: String){
        let vc = AllViewController(cat: cat, subCat: subCat)
        childVcs.append(vc)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        startGlobleHeyCarloudyNews(vc: self)
        setupUI()
        GloableSiriFunc.shareInstance.createWaringLabelInCarloudy()
        GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: "Say 'Open CarloudyNews' to activate speech")
        

        
    }
    
//    func sendToCarloudy(title: String){
//        let labelTextSize = 30
//        let carloudyBLE = CarloudyBLE.shareInstance
//        if let pairkey = carloudyBlePairKey_{
//            carloudyBLE.newKeySendToPairAndorid_ = pairkey
//        }
//        carloudyBLE.startANewSession(appId: carloudyAppStoreAppKey_)
//        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "9", labelTextSize: labelTextSize, postionX: 05, postionY: 65, width: 00, height: 00)
//        carloudyBLE.sendMessage(textViewId: "9", message: title)
//    }
    
    deinit {
        ZJPrint("deinit----LikeViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let titles = UserDefaults.standard.array(forKey: titles_StringDescription) as? [String]{
            if maintitles != titles{
                maintitles = titles
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}



extension LikeViewController{
    fileprivate func setupUI(){
        setupNavigationBar()
        view.addSubview(pageContentView)
        pageContentView.addSubview(settingView)
        settingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: settingViewHeight)
    }
    
    fileprivate func setupNavigationBar(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageTitleView)
//        let size = CGSize(width: 40, height: 40)
//        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
//        navigationItem.rightBarButtonItem = searchItem
//        let guesture = UITapGestureRecognizer(target: self, action: #selector(rightBarButtonItemClicked))
        let searchBtn = UIBarButtonItem(image: UIImage(named: "btn_search"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        let siriBtn = UIBarButtonItem(image: UIImage(named: "Siri")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(siriBtnClicked))
        
        navigationItem.rightBarButtonItems = [searchBtn, siriBtn]
        
    }
    
    @objc fileprivate func siriBtnClicked(){
        let storyboard = UIStoryboard(name: "PrimaryViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PrimaryViewController")
        let nvc = UINavigationController(rootViewController: controller)
        self.present(nvc, animated: true, completion: nil)
    }
    
    @objc fileprivate func rightBarButtonItemClicked(){
        let vc = AddCategoriesViewController()
        vc.titles = maintitles
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
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
