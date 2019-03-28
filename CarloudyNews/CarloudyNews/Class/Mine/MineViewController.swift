//
//  MineViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//


import UIKit


class MineViewController: UIViewController {
    
//    var mainViewController: MainViewController?
    private lazy var myArray: Array = {
        return [[["icon":"mine_feedBack", "title": "Talk to CarloudyNews"],
                 ["icon":"mine_setting", "title": "Carloudy Setting"]],
                
                [["icon":"mine_feedBack", "title": "夜间模式"],
                 ["icon":"mine_mail", "title": "我要反馈"],
                 ["icon":"mine_judge", "title": "给我们评分"]],
        
            [["icon":"mine_feedBack", "title": "about"],
             ["icon":"mine_mail", "title": "feedback"],
             ["icon":"mine_judge", "title": "rate"]],
            
            [["icon":"mine_feedBack", "title": "about"],
             ["icon":"mine_mail", "title": "feedback"],
             ["icon":"mine_judge", "title": "rate"]]
        ]
        
    }()
    
    private lazy var head: MineHead = {
        return MineHead(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    }()
    
    let cellId = "cellId"
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.background
        tv.delegate = self
        tv.dataSource = self
//        tv.layer.cornerRadius = 50
//        tv.layer.masksToBounds = true
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.alpha = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
}



extension MineViewController{
    
    fileprivate func setupUI(){
        
        view.addSubview(tableView)
        navigationItem.title = "Setting"
//        let navigationBarY = navigationController?.navigationBar.frame.maxY ?? 88
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.parallaxHeader.view = head
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .topFill
        
        
        head.bgView.isUserInteractionEnabled = true
        let guesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        head.bgView.addGestureRecognizer(guesture)
    }
    
    @objc fileprivate func imageClicked(){
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.alpha = 1
            self.tableView.contentOffset.y = -(zjStatusHeight+zjNavigationBarHeight-35) + 1
        }
    }
//    @objc fileprivate func goback(){
//        self.dismiss(animated: true, completion: nil)
//    }
}


extension MineViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = myArray[section]
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        let sectionArray = myArray[indexPath.section]
        let dict: [String: String] = sectionArray[indexPath.row]
        cell.imageView?.image = UIImage(named: dict["icon"] ?? "")
        cell.textLabel?.text = dict["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ZJPrint(indexPath.item)
        ZJPrint(indexPath.row)
        if indexPath == [0, 0]{
            let talkToNews = TalkToCarloudyNewsViewController()
            navigationController?.pushViewController(talkToNews, animated: true)
        }else if indexPath == [0, 1]{
            let csVC = CarloudySettingViewController()
            navigationController?.pushViewController(csVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ZJPrint(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y > -(zjStatusHeight+zjNavigationBarHeight-35){
            navigationController?.navigationBar.frame.origin.y = -(scrollView.contentOffset.y) - zjNavigationBarHeight + 35
        }
        
        if scrollView.contentOffset.y > -(zjStatusHeight+100){
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.0) {
                self.navigationController?.navigationBar.alpha = 0
            }
        }
        
        
    }
    
    
}


