//
//  CarloudyBLE.swift
//  CarloudyiOS
//
//  Created by Cognitive AI Technologies on 5/14/18.
//  Copyright © 2018 zijia. All rights reserved.
//

import Foundation
import CoreBluetooth
import CryptoSwift
import CoreLocation
import SystemConfiguration.CaptiveNetwork

extension String {
    subscript  (r: Range<Int>) -> String {
        get {
            let myNSString = self as NSString
            let start = r.lowerBound
            let length = r.upperBound - start + 1
            return myNSString.substring(with: NSRange(location: start, length: length))
        }
    }
}

open class CarloudyBLE: NSObject {
    
    public static let shareInstance : CarloudyBLE = {
        let ble = CarloudyBLE()
        ble.getPairKey()
        return ble
    }()
    public let defaultKeySendToPairAndorid_ = "passwordpassword"
    open var newKeySendToPairAndorid_ = "passwordpassword"{
        didSet{
            savePairKey()
        }
    }
    open var peripheralManager = CBPeripheralManager()
    
    ///The array saved all datas
    var dataArray : Array<String> = []
    open var dataArrayTimerInterval = 0.15
    weak var dataArrayTimer : Timer?
    public let startNewSessionPrefixKey = "z0"
    public let createNewTextViewPrefixKey = "za"
    public let sendNewTextViewPrefixKey = "zb"
    public let createNewImageNewPrefixKey = "zc"
    public let otherCommandPrefixKey = "zd"
    public let updateImagesWithoutUpdateOTASSID = "cv"
    public let updateImagesWithoutUpdateOTAPassword = "cq"
    
    public override init() {
        super.init()
    }
    
    
    /// “z0” + “(app_id)”
    /// Example: z0a5ef3350
    /// This message must be sent prior to other related commands.
    /// - Parameter appId: app_id (8): provided by Carloudy after user registered account(register your app and get appId at betastore.carloudy.com). Will define folders and start a new session belongs to the specific app.
    
    open func startANewSession(appId: String){
        print("----startANewSession")
        sendMessageForSplit(prefix: startNewSessionPrefixKey, message: appId)
    }
    
    fileprivate func twoletters(number: Int) -> String{
        let str = String(number)
        if str.count == 2{
            return str
        }
        if str.count == 1{
            let tempStr = "0" + str
            return tempStr
        }
        print("labelTextSize, postionX, postionY, width, height must be 2 digits")
        return ""
    }
    
    
    
    /// “za” + “(textViewId)” + “(font size)” + “(x)” + “(y)” + “(width)” + “(height)”   Example: za13205364200, This command must be sent prior to “zb” commands.
    ///
    /// - Parameters:
    ///   - textViewId: (1) [0-9, a-z]: User defined display section id for distinguishing among other display sections
    ///   - labelTextSize: (2) [01-99]: font size for texts in display section; “00” for default size
    ///   - postionX: (2) [00-90]: position-x for display section
    ///   - postionY: (2) [00-72]: position-y for display section
    ///   - width: (2) [01-90]: width for display section; “00” for auto fit width
    ///   - height: (2) [01-72]: height for display section; “00” for auto fit height
    open func createIDAndViewForCarloudyHud(textViewId: String, labelTextSize: Int, postionX: Int, postionY: Int, width: Int, height: Int){
        //检测 必须是两位数 如果不是两位数 则前边加0
        let labelTextSizeString = twoletters(number: labelTextSize)
        let postionXString = twoletters(number: postionX)
        let postionYString = twoletters(number: postionY)
        let widthString = twoletters(number: width)
        let heightString = twoletters(number: height)
        
        let finalStr = textViewId + labelTextSizeString + postionXString + postionYString + widthString + heightString
        sendMessageForSplit(prefix: createNewTextViewPrefixKey, message: finalStr)
        
    }
    
    
    
    /// “zc” + “(pic_id)” + “(x)” + “(y)” + “(width)” + “(height)”, Example: zc0100563030, This command must be sent after “z0”. Otherwise, it’s meaningless and will be ignored. The picture to display will keep the original aspect ratio. Command only has “pic_id” without other parameters will remove the image.
    ///
    /// - Parameters:
    ///   - picID: (2) [a-z]: unique id(such as: aa, zb..) for picture to display. The “pic_id” must be the same as the picture name uploaded by the user
    ///   - postionX: (2) [00-90]: position-x for display section
    ///   - postionY: (2) [00-72]: position-y for display section
    ///   - width: (2) [01-90]: width for display section; “00” for auto fit width
    ///   - height: (2) [01-72]: height for display section; “00” for auto fit height
    open func createPictureIDAndImageViewForCarloudyHUD(picID: String, postionX: Int, postionY: Int, width: Int, height: Int){
        let postionXString = twoletters(number: postionX)
        let postionYString = twoletters(number: postionY)
        let widthString = twoletters(number: width)
        let heightString = twoletters(number: height)
        let finalStr = picID + postionXString + postionYString + widthString + heightString
        sendMessageForSplit(prefix: createNewImageNewPrefixKey, message: finalStr)
    }
    
    open func removeImageViewForCarloudyHUD(picID: String){
        sendMessageForSplit(prefix: createNewImageNewPrefixKey, message: picID)
    }
    
    
    /// “zb” + “(textViewId)” + “(text)”, Example: zb1Hello, World!, This command must be sent after “za” and “z0”. Otherwise, it’s meaningless and will be ignored. This command can be used to replace old text with “text” only for the specific “id” after “za” has been received and without sending “za” again.
    ///
    /// - Parameters:
    ///   - textViewId: (1) [0-9, a-z]: User defined display section id for distinguishing among other display sections.
    ///   - message: text string for display section
    open func sendMessage(textViewId: String, message: String){
        let finalStr = textViewId + message
        sendMessageForSplit(prefix: sendNewTextViewPrefixKey, message: finalStr)
    }
    
    
    
    /// “zb” + “(textViewId)” + “(text)”, Example: zb1Hello, World!, This command must be sent after “za” and “z0”. Otherwise, it’s meaningless and will be ignored. This command can be used to replace old text with “text” only for the specific “id” after “za” has been received and without sending “za” again.
    ///
    /// - Parameters:
    ///   - textViewId: (1) [0-9, a-z]: User defined display section id for distinguishing among other display sections.
    ///   - message: text string for display section
    ///   - highPriority: default is false,
    ///   - coverTheFront: default is false, will overwrite the data if it is true.
    open func sendMessage(textViewId: String, message : String, highPriority : Bool = false, coverTheFront: Bool = false){
        let finalStr = textViewId + message
        sendMessageForSplit(prefix: sendNewTextViewPrefixKey, message: finalStr, highPriority: highPriority, coverTheFront: coverTheFront)
    }
    
    
    /// “zd” + “(command_id)” + “(app_id)”, Example: zd2a5ef3350, This command must be sent after “z0”. Otherwise, it’s meaningless and will be ignored.
    ///
    /// - Parameters:
    ///   - commandID: (1) [0-9]: 0: remove all contents on display,  1: stop / exit display session, 2: heartbeat signal without any messages, for display session staying alive
    ///   - appId: (8): provided by Carloudy after user registered account(register your app and get appId at betastore.carloudy.com)
    open func sendAppCommand(commandID: String, appId: String){
        let finalStr = commandID + appId
        sendMessageForSplit(prefix: otherCommandPrefixKey, message: finalStr)
    }
    
    /// highPriority only works if message.count less or equal than maxLenthEachData = 11
    ///if u set coverTheFront ture, all the elements in dataArray with same prefix will be removed.
    fileprivate func sendMessageForSplit(prefix : String, message : String, highPriority : Bool = false, coverTheFront: Bool = false){
        //        if prefix.count > 2{
        //            print("prefix better has 2 characters")
        //        }
        if coverTheFront == true{
            for (index, data) in dataArray.enumerated(){
                if String(data[data.index(data.startIndex, offsetBy: 2)..<data.index(data.startIndex, offsetBy: 4)]) == prefix{
                    sync(lock: dataArray, closure: {
                        self.dataArray.remove(at: index)
                    })
                }
            }
        }
        
        let maxLenthEachData = 11
        let datasCount = Int(ceil(Double(message.count) / Double(maxLenthEachData)))
        let startingValue = Int(("0" as UnicodeScalar).value) // 48
        let total = Character(UnicodeScalar(datasCount + startingValue)!)
        
        for index in 0..<datasCount{
            
            let i2 = Character(UnicodeScalar(index + startingValue)!)
            var piece = ""
            if (message.count - (maxLenthEachData * index)) > maxLenthEachData{
                piece = "\(total)\(i2)\(prefix)\(message[(maxLenthEachData * index)..<(maxLenthEachData * (index + 1) - 1)])"
            }else{
                piece = "\(total)\(i2)\(prefix)\(message[(maxLenthEachData * index)..<(message.count-1)])"
            }
            
            if highPriority == true && piece.hasPrefix("10"){
                //                for (index, data) in dataArray.enumerated(){
                //                    if data.hasPrefix("10\(prefix)"){
                //                        dataArray.remove(at: index)
                //                    }
                //                }
                //                dataArray.insert(piece, at: 0)
                sync(lock: dataArray as Array<Any>, closure: {
                    dataArray.insert(piece, at: 0)
                })
            }else{
                sync(lock: dataArray as Array<Any>, closure: {
                    dataArray.append(piece)
                })
            }
            
        }
        openDataArrayTimer()
    }
    
    func openDataArrayTimer(){
        guard dataArrayTimer == nil else {
            return
        }
        dataArrayTimer =  Timer.scheduledTimer(withTimeInterval: dataArrayTimerInterval, repeats: true) { (_) in
            if self.dataArray.count > 0{
                let stringToSend = self.dataArray.first
                print("-------------dataArray.count: --\(self.dataArray.count)")
                self.sync(lock: self.dataArray, closure: {
                    self.dataArray.removeFirst()
                })
                self.sendMessage(message: stringToSend ?? "")
            }else{
                self.dataArrayTimer?.invalidate()
            }
        }
    }
    
    fileprivate func sendMessage(message : String){
        let data = stringToData(str: message)
        sendDataToPeripheral(data: data as NSData)
    }
    
    
    open func sendDataToPeripheral(data: NSData) {
        let dataToSend = data
        startAdvertisingToPeripheral(dataToSend: dataToSend)
    }
    
    open func startAdvertisingToPeripheral(dataToSend : NSData) {
        let datastring = NSString(data:dataToSend as Data, encoding:String.Encoding.utf8.rawValue)! as String
        //            datastring = getAlphaNumericValue(str: datastring)
        let time1 = 130
        let time2 =  20
        let time = DispatchTime.now() + .milliseconds(time2)          //10
        let stop = DispatchTime.now() + .milliseconds(time1)      //140
        do {
            let aes = try AES(key: newKeySendToPairAndorid_, iv: "drowssapdrowssap", padding: .pkcs7)
            let ciphertext = try aes.encrypt(Array(datastring.utf8))
            DispatchQueue.main.asyncAfter(deadline: time) {
                () -> Void in self.sendMessage(message: ciphertext );
            }
            DispatchQueue.main.asyncAfter(deadline: stop) {
                () -> Void in self.peripheralManager.stopAdvertising();
            }
        } catch { }
    }
    
    open func stringToData(str : String) -> Data{
        return str.data(using: String.Encoding.utf8)!
    }
    
    open func stopAdvertisingToPeripheral() {
        self.peripheralManager.stopAdvertising()
    }
    
    open func intToHex(value : Int) -> String{
        let st = String(format:"%02X", value)
        return st
    }
    
    open func sendMessage(message: Array<UInt8>){
        var UUID : String = ""
        var i = message.count - 1
        while i > -1 {
            let ints : Int = Int(message[i])
            UUID = UUID + intToHex(value: ints)
            i = i - 1
        }
        
        UUID = UUID[0..<31]
        let temp1 = UUID[0..<7] + "-" + UUID[8..<11] + "-"
        let temp2 = UUID[12..<15] + "-" + UUID[16..<19] + "-"
        let temp3 = UUID[20..<31]
        let messageUUID = temp1 + temp2 + temp3
        peripheralManager.stopAdvertising()
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: messageUUID)]])
    }
    
    
    
}

//Updata images from server, Wifi
extension CarloudyBLE{
    
    open func alertViewToUpdateImagesFromServer(){
        let alert = UIAlertController(title: "Update images", message: "Let Carloudy connect to Wifi, please make sure 2.4G WIFI only!", preferredStyle: UIAlertController.Style.alert)
        let updateAction = UIAlertAction(title: "Update", style: .default) { (alertAction) in
            guard let wifi = alert.textFields?[0].text,
                let passWord = alert.textFields?[1].text else{
                    return
            }
            if wifi == "" || passWord == ""{
                let badFormAlert = UIAlertController(title: "warning", message: "Bad format, please try it again", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in})
                badFormAlert.addAction(okAction)
                if let topController = UIApplication.topViewController() {
                    topController.present(badFormAlert, animated:true, completion: nil)
                }
                return
            }else{
                let feedBackAlert = UIAlertController(title: "Note", message: "Wifi and password were sent to Carloudy, please check your Carloudy device to update. if it doesn't work please try it agin", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in})
                feedBackAlert.addAction(okAction)
                if let topController = UIApplication.topViewController() {
                    topController.present(feedBackAlert, animated:true, completion: nil)
                }
                
            }
            self.sendMessageForSplit(prefix: self.updateImagesWithoutUpdateOTASSID, message: wifi)
            self.sendMessageForSplit(prefix: self.updateImagesWithoutUpdateOTAPassword, message: passWord)
            self.sendMessageForSplit(prefix: self.updateImagesWithoutUpdateOTASSID, message: wifi)
            self.sendMessageForSplit(prefix: self.updateImagesWithoutUpdateOTAPassword, message: passWord)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in}
        alert.addTextField { (textField) in
            if let ssid = self.getWiFiSsid(){
                textField.text = ssid
            }else{
                textField.placeholder = "Enter Your Wifi"
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Your Password"
        }
        alert.addAction(cancelAction)
        alert.addAction(updateAction)
        if let topController = UIApplication.topViewController() {
            topController.present(alert, animated:true, completion: nil)
        }
        
    }
    
    
    /// if this func does not work, you need turn your Access WIFI Information on if necessary.
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
}

extension CarloudyBLE{
    
    open func pairButtonClicked(finish: @escaping ((String)->())){
        newKeySendToPairAndorid_ = "passwordpassword"
        let random6Num = String(arc4random_uniform(899999) + 100000)
        let stringToSend = "10key\(random6Num)"
        let dataToSend = stringToData(str: stringToSend)
        sendDataToPeripheral(data: dataToSend as NSData)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.newKeySendToPairAndorid_ = "\(random6Num)1111111111"
            finish(random6Num)
        }
    }
    
    open func toCarloudyApp() {
        let url = URL(string: "CarloudyiOS://")
        guard url != nil else {
            return
        }
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!)
        }else{
            print("user did not install Carloudy app")
        }
    }
    
    
    
}

//MARK: -- pairkey
extension CarloudyBLE{
    
    open func openUrl(url: URL){
        let urlStr = String(describing: url)
        if let pairKey = urlStr.components(separatedBy: "://").last{
            newKeySendToPairAndorid_ = pairKey
            print("2----\(newKeySendToPairAndorid_)")
        }
    }
    
    open func savePairKey(){
        UserDefaults.standard.set(newKeySendToPairAndorid_, forKey: "newKeySendToPairAndorid_")
    }
    
    open func getPairKey(){
        if UserDefaults.standard.object(forKey: "newKeySendToPairAndorid_") != nil {
            newKeySendToPairAndorid_ = UserDefaults.standard.object(forKey: "newKeySendToPairAndorid_") as! String
        }
    }
}


///数组安全问题
extension CarloudyBLE{
    func sync(lock: Array<Any>, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    /*
     var list = NSMutableArray()
     sync (list) {
     list.addObject("something")
     }
     */
}

