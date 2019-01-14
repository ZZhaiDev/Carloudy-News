//
//  AddCategoriesViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/14/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

extension UINavigationBar
{
    var lagreTitleHeight: CGFloat {
        let maxSize = self.subviews
            .filter { $0.frame.origin.y > 0 }
            .max { $0.frame.origin.y < $1.frame.origin.y }
            .map { $0.frame.size }
        return maxSize?.height ?? 0
    }
}

class AddCategoriesViewController: UIViewController {

    var titles: [String]?
    
   fileprivate let scrollView: UIScrollView = {
       let sv = UIScrollView(frame: CGRect(x: 0, y: zjStatusHeight + zjNavigationBarHeight, width: zjScreenWidth, height: zjScreenHeight - (zjStatusHeight + zjNavigationBarHeight)))
        sv.contentSize = CGSize(width: zjScreenWidth, height: 1000)
//        sv.backgroundColor = .red
        return sv
    }()
    
   fileprivate let textView: UITextField = {
       let y = UINavigationBar().lagreTitleHeight
        let width = zjScreenWidth - 60 - 70 - 15
        let tv = UITextField(frame: CGRect(x: 30, y: y, width: width, height: 35))
        tv.backgroundColor = UIColor.darkGray
    
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tv.frame.size.height))
        tv.leftView = paddingView
        tv.leftViewMode = UITextField.ViewMode.always
    
        tv.attributedPlaceholder = NSAttributedString(string: "add categories",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.background])
        tv.textColor = .white
        tv.tintColor = .white
        tv.layer.cornerRadius = 15
        tv.layer.masksToBounds = true
        return tv
    }()
    
  fileprivate lazy var addButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        button.setTitle("  add  ", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addButonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func addButonClicked(){
        guard textView.text != nil, textView.text != "" else{
            return
        }
        titles?.append(textView.text!)
        textView.text = ""
        setupUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}



extension AddCategoriesViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
        navigationController?.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc fileprivate func dismissController(){
        self.dismiss(animated: true) {
            if let topViewControler = UIApplication.topViewController() as? LikeViewController{
                if self.titles != nil{
//                    topViewControler.maintitles = self.titles!
//                    topViewControler.pageContentView.collectionView.reloadData()
                    
                }
            }
        }
    }
    
    fileprivate func setupUI(){
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(dismissController))
        
        self.title = "Add Categories"
        self.view.backgroundColor = UIColor.background
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(textView)
        self.scrollView.addSubview(addButton)
        addButton.anchor(top: textView.topAnchor, left: textView.rightAnchor, bottom: textView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        guard  titles != nil else{
            return
        }
        
        var baseHeight:CGFloat = UINavigationBar().lagreTitleHeight + 35 + 15
        var baseX:CGFloat = 30
        let padding:CGFloat = 15
        for title in titles!{
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.randomColor()
            
            let size = CGSize(width: 1000, height: 1000)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            let estimatedFrame = NSString(string: title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let height = estimatedFrame.height+padding
            let width = estimatedFrame.width+padding
            
            var nextX = baseX + (width + 15)
            if nextX > zjScreenWidth{
                baseX = 30
                nextX = baseX + (width + 15)
                baseHeight += (height + 20)
            }
            button.frame = CGRect(x: baseX, y: baseHeight, width: width, height: height)
            baseX = nextX
           
            self.scrollView.addSubview(button)
        }
    }
    
    
}



