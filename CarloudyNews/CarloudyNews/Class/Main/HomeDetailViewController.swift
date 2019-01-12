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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZJProgressHUD.showProgress(supView: self.view, bgFrame: CGRect(x: 0, y: 0, width: zjScreenWidth, height: zjScreenHeight),imgArr: getloadingImages(), timeMilliseconds: 90, bgColor: UIColor.white, scale: 0.8)
        
        self.view.backgroundColor = UIColor.background
        if let url = article?.url{
            if let urlStr = URL(string: url){
                self.webView.load(URLRequest(url: urlStr))
                
            }
        }
        
    }
    
    deinit {
        stopAnimations()
    }

}


extension HomeDetailViewController: UIWebViewDelegate, WKNavigationDelegate{
    
    fileprivate func stopAnimations(){
        ZJProgressHUD.hideAllHUD()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimations()
        ZJPrint("5555")
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        ZJPrint("000")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        ZJPrint("11111")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZJPrint("222222")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        ZJPrint("333333")
        return false
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
