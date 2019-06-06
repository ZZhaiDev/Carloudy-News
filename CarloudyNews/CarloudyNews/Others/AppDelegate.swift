//
//  AppDelegate.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit
import CarloudyiOS
import ApiAI

let testView = UILabel(frame: CGRect(x: 50, y: 80, width: 200, height: 50))
func test(){
    let window = UIApplication.shared.keyWindow!
    testView.backgroundColor = UIColor.white
    testView.textColor = .black
    window.addSubview(testView)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = .orange
        //常亮
        UIApplication.shared.isIdleTimerDisabled = true
        
        isEnableOpenCarloudyNews = UserDefaults.standard.bool(forKey: "isEnableOpenCarloudyNews")
        isListenForReadNews = UserDefaults.standard.integer(forKey: "isListenForReadNews")
        
        //第一次打开，默认isListenForReadNews == 1
        let str = "openBefore"
        if UserDefaults.standard.bool(forKey: str) == false{
            isListenForReadNews = 1
            UserDefaults.standard.set(true, forKey: str)
        }
        
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "7d63d3809c31490b92a0187eb3dc0abe"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        
        
        ZJPrint(isEnableOpenCarloudyNews)
        ZJPrint(isListenForReadNews)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let vc = UIApplication.topViewController(){
            startGlobleHeyCarloudyNews(vc: vc)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        ZJPrint("123123133213")
        stopGlobleHeyCarloudyNews()
    }
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ZJPrint(url)        //com.CognitiveAI.CarloudyWeather://9145221111111111
        if let pairKey = url.absoluteString.components(separatedBy: "://").last{
            carloudyBlePairKey_ = pairKey
        }
        let noti = Notification.init(name: Notification.Name(rawValue: launchAppByCarloudyNotificationKey_), object: nil, userInfo: nil)
        NotificationCenter.default.post(noti)
        return true
    }


}

