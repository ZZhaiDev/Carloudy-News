//
//  HomeDetailViewController.swift
//  CarloudyNews
//
//  Created by zijia on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import  WebKit

class HomeDetailViewController: UIViewController {

    var article: Article?
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZJProgressHUD.showProgress(supView: self.view, bgFrame: CGRect(x: 0, y: 0, width: zjScreenWidth, height: zjScreenHeight),imgArr: getloadingImages(), timeMilliseconds: 90, bgColor: UIColor.white, scale: 0.8)
        
        self.view.backgroundColor = UIColor.background
        if let url = article?.url{
            if let urlStr = URL(string: url){
                webView.load(URLRequest(url: urlStr))
            }
        }
        
    }

}


extension HomeDetailViewController: UIWebViewDelegate, WKNavigationDelegate{
    
    fileprivate func stopAnimations(){
        ZJProgressHUD.hideAllHUD()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimations()
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopAnimations()
        ZJPrint(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        stopAnimations()
        ZJPrint(error)
    }
    
    
}
