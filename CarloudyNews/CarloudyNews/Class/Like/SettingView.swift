//
//  SettingView.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/11/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit



var sortbySegmentedControl_StringDescription: String = "sortbySegmentedControl_StringDescription"
let sortbySegmentedControl_Array: [String] = ["Default", "popularity", "time"]
//var sortbySegmentedControl_DefaultValue: Int = 0
var sortbyStyle_ = sortbySegmentedControl_Array[0]
var cellStyleSegmentedControl_StringDescription: String = "cellStyleSegmentedControl_StringDescription"
let cellStyleSegmentedControl_Array: [String] = ["Default", "Normal", "Small"]
//var cellStyleSegmentedControl_DefaultValue: Int = 0
var cellStyle_ = cellStyleSegmentedControl_Array[0]
let textDatePicker_: String = "textDatePicker"
let toDatePicker_: String = "toDatePicker"

public protocol SettingViewDelegate{
    func settingView(url: String, cellStyle: String)
}

class SettingView: UIView {
    
    var delegate: SettingViewDelegate?
    @IBOutlet weak var sortbySegmentedControl: UISegmentedControl!
    @IBAction func sortbySegmentedControlClicked(_ sender: Any) {
        showUpdateButton()
        ZJPrint(sortbySegmentedControl.selectedSegmentIndex)
    }
    @IBOutlet weak var textDatePicker: UITextField!
    @IBOutlet weak var toDatePicker: UITextField!
    @IBOutlet weak var cellStyleSegmentedControl: UISegmentedControl!
    @IBAction func cellStyleSegmentedControlClicked(_ sender: Any) {
        showUpdateButton()
    }
    
    let datePicker = UIDatePicker()
    @IBOutlet weak var updateButton: UIButton!
    @IBAction func updateButtonClicked(_ sender: Any) {
        hideUpdateButton()
        saveUserDefaultAndRetrieveNewDate()
    }
    fileprivate let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retrieveUserDefault()
        setupUI()
        setupDatePicker()
    }
    
    func retrieveUserDefault(){
        let sortby  = UserDefaults.standard.integer(forKey: sortbySegmentedControl_StringDescription)
        sortbySegmentedControl.selectedSegmentIndex = sortby
        
        let cellStyle = UserDefaults.standard.integer(forKey: cellStyleSegmentedControl_StringDescription)
        cellStyleSegmentedControl.selectedSegmentIndex = cellStyle
    }
}



// MARK:- UI
extension SettingView{
    fileprivate func setupUI(){
        updateButton.layer.cornerRadius = 10
        updateButton.layer.masksToBounds = true
        if isEditingSettingView == false{
            updateButton.isHidden = true
        }
        
    }
    
    fileprivate func setupDatePicker(){
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -29, to: Date())
        datePicker.maximumDate = Date()
        showDatePicker(textF: textDatePicker, tag: 0)
        showDatePicker(textF: toDatePicker, tag: 1)
        
        formatter.dateFormat = "yyyy-MM-dd"
        textDatePicker.text = formatter.string(from: Date())
        toDatePicker.text = formatter.string(from: Date())
        
        textDatePicker.delegate = self
        toDatePicker.delegate = self
    }
    
    fileprivate func hideUpdateButton(){
        isEditingSettingView = false
        updateButton.isHidden = true
        self.frame.size.height = settingViewHeight
        if let topViewController = UIApplication.topViewController() as? LikeViewController{
            UIView.animate(withDuration: 1.0) {
                topViewController.pageContentView.collectionView.contentOffset.y = 0
                topViewController.pageContentView.collectionView.contentInset.top = 0
            }
        }
    }
    
    fileprivate func saveUserDefaultAndRetrieveNewDate(){
        if textDatePicker.text == nil || toDatePicker == nil{ return }
        UserDefaults.standard.set(sortbySegmentedControl.selectedSegmentIndex, forKey: sortbySegmentedControl_StringDescription)
        UserDefaults.standard.set(textDatePicker.text!, forKey: textDatePicker_)
        UserDefaults.standard.set(toDatePicker.text!, forKey: toDatePicker_)
        UserDefaults.standard.set(cellStyleSegmentedControl.selectedSegmentIndex, forKey: cellStyleSegmentedControl_StringDescription)
//        https://newsapi.org/v2/everything?q=apple&from=2019-01-10&to=2019-01-10&sortBy=popularity&apiKey=b7f7add8d89849be8c82306180dac738
        let userInfo:[String: Any] = ["sortby": sortbySegmentedControl.selectedSegmentIndex, "from": textDatePicker.text!, "to": toDatePicker.text!, "cellStyle": cellStyleSegmentedControl.selectedSegmentIndex]
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: settingViewUpdateAndReloadDataNotificationKey_), object: nil, userInfo: userInfo))
    }
}


extension SettingView{
    class func settingView() -> SettingView{
        return Bundle.main.loadNibNamed("SettingView", owner: nil, options: nil)?.first as! SettingView
    }
    
    func showDatePicker(textF: UITextField, tag: Int){
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker(sender:)));
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textF.inputAccessoryView = toolbar
        textF.inputView = datePicker
    }
    
    fileprivate func showUpdateButton(){
        if isEditingSettingView == true{ return }
        isEditingSettingView = true
        self.frame.size.height = settingViewHeight
        
        if let topViewController = UIApplication.topViewController() as? LikeViewController{
            ZJPrint(topViewController.pageContentView.collectionView.contentInset.top)
            UIView.animate(withDuration: 1.0) {
                self.updateButton.isHidden = false
                topViewController.pageContentView.collectionView.contentOffset.y = -30
                topViewController.pageContentView.collectionView.contentInset.top = 55
                
            }
        }
        
    }
    
    
    @objc func donedatePicker(sender: UITextField){
        showUpdateButton()
        if sender.tag == 0{
            textDatePicker.text = formatter.string(from: datePicker.date)
        }else{
            toDatePicker.text = formatter.string(from: datePicker.date)
        }
        self.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
}


extension SettingView: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showUpdateButton()
    }
}
