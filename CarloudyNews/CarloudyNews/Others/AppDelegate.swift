//
//  AppDelegate.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = .orange
        
        isEnableOpenCarloudyNews = UserDefaults.standard.bool(forKey: "isEnableOpenCarloudyNews")
        ZJPrint(isEnableOpenCarloudyNews)
        
        return true
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

