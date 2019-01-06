//
//  AllViewController.swift
//  CarloudyNews
//
//  Created by zijia on 1/5/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class AllViewController: UIViewController {

    lazy var homeViewModel = HomeViewModel()
    var parameters: String = "bitcoin"
    
    fileprivate lazy var homeView: HomeMainView = { [unowned self] in
        let hv = HomeMainView(frame: CGRect(x: 0, y: 0, width: zjScreenWidth, height: self.view.bounds.size.height))
        hv.backgroundColor = UIColor.background
        hv.delegate = self
        return hv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.addSubview(homeView)
        // Do any additional setup after loading the view.
    }
    


}


// MARK:- API
extension AllViewController{
    fileprivate func loadData(){
        let str = "https://newsapi.org/v2/everything?q=\(parameters)&apiKey=b7f7add8d89849be8c82306180dac738"
        homeViewModel.loadNews(str: str) {
            DispatchQueue.main.async {
                self.homeView.articles = self.homeViewModel.articles
            }
        }
    }
}


// MARK:- HomeMainViewDelegate
extension AllViewController: HomeMainViewDelegate{
    func homeMainView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articles = self.homeViewModel.articles
        let article = articles[indexPath.item]
        let homeDetailVC = HomeDetailViewController()
        homeDetailVC.article = article
        navigationController?.pushViewController(homeDetailVC, animated: true)
    }
}




