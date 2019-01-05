//
//  HomeViewController.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var homeViewModel = HomeViewModel()
    
    fileprivate lazy var homeView: HomeMainView = { [unowned self] in
        let hv = HomeMainView(frame: self.view.bounds)
        hv.backgroundColor = UIColor.background
        hv.delegate = self
        return hv
    }()
    
    override func loadView() {
        super.loadView()
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
}


// MARK:- ui
extension HomeViewController{
    fileprivate func setupUI(){
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


// MARK:- API
extension HomeViewController{
    fileprivate func loadData(){
        let str = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=b7f7add8d89849be8c82306180dac738"
        homeViewModel.loadNews(str: str) {
            DispatchQueue.main.async {
                self.homeView.articles = self.homeViewModel.articles
            }
        }
    }
}


// MARK:- HomeMainViewDelegate
extension HomeViewController: HomeMainViewDelegate{
    func homeMainView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articles = self.homeViewModel.articles
        let article = articles[indexPath.item]
        let homeDetailVC = HomeDetailViewController()
        homeDetailVC.article = article
        navigationController?.pushViewController(homeDetailVC, animated: true)
    }
    
    
}
