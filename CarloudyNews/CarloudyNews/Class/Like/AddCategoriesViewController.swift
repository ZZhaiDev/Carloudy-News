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
    var savedTitles: [String]?
    var titleButtons: [UIButton] = [UIButton]()
    
   fileprivate let scrollView: UIScrollView = {
       let sv = UIScrollView(frame: CGRect(x: 0, y: zjStatusHeight + zjNavigationBarHeight, width: zjScreenWidth, height: zjScreenHeight - (zjStatusHeight + zjNavigationBarHeight)))
        sv.contentSize = CGSize(width: zjScreenWidth, height: 1000)
//        sv.backgroundColor = .red
        return sv
    }()
    
   fileprivate let textView: UITextField = {
       let y = UINavigationBar().lagreTitleHeight + 20
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
    
    fileprivate let deleteButton: UIButton = {
        let y = zjScreenHeight - zjStatusHeight - zjNavigationBarHeight - UINavigationBar().lagreTitleHeight - 150
       let button = UIButton(frame: CGRect(x: zjScreenWidth/2 - 25, y: y, width: 50, height: 50))
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
  fileprivate lazy var addButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        button.setTitle("  add  ", for: .normal)
//        button.backgroundColor = .blue
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addButonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func addButonClicked(){
        guard textView.text != nil, textView.text != "" else{
            return
        }
        titles?.append(textView.text!.replacingOccurrences(of: " ", with: "20%"))
        textView.text = ""
        for button in titleButtons{
            button.removeFromSuperview()
        }
        setupUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedTitles = self.titles
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
                if self.titles != nil && self.titles != self.savedTitles{
                    topViewControler.maintitles = self.titles!
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
        scrollView.addSubview(deleteButton)
        self.scrollView.addSubview(textView)
        self.scrollView.addSubview(addButton)
        addButton.anchor(top: textView.topAnchor, left: textView.rightAnchor, bottom: textView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        guard  titles != nil else{
            return
        }
        
        var baseHeight:CGFloat = UINavigationBar().lagreTitleHeight + 35 + 15 + 20
        var baseX:CGFloat = 30
        let padding:CGFloat = 15
        for (index, title) in titles!.enumerated(){
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(UIColor.white, for: .normal)
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
            
            button.tag = index
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
//            panGestureRecognizer.delegate = self
            button.addGestureRecognizer(panGestureRecognizer)
            
            baseX = nextX
            titleButtons.append(button)
            ZJPrint(titleButtons)
            self.scrollView.addSubview(button)
        }
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let gview = recognizer.view as! UIButton
        let translation = recognizer.translation(in: gview.superview)
        
        switch recognizer.state {
        case .began, .changed:
            gview.layer.transform = CATransform3DMakeTranslation(translation.x, translation.y, 0)
            // OR
        // imgView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        case .ended:
            if deleteButton.frame.intersects(gview.layer.frame) {
                animateDelete(sender: gview)
            } else {
                moveBack(sender: gview)
            }
        default:
            moveBack(sender: gview)
        }
    }
    
    func animateDelete(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.alpha = 0
        }) { _ in
//            ZJPrint(sender.tag)
            self.titles?.remove(at: sender.tag)
            for button in self.titleButtons{
                button.removeFromSuperview()
            }
            self.setupUI()
            sender.isHidden = true
        }
    }
    
    func moveBack(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
}



