//
//  SettingView.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/11/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class SettingView: UIView {
    
    @IBOutlet weak var textDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ZJPrint("awakeFromNib")
//        var components = DateComponents()
//        components.month = -1
//        let minDate = Calendar.current.date(byAdding: components, to: Date())
//
//
//        let maxDate = Calendar.current.date(byAdding: DateComponents(), to: Date())
//
//        datePicker.minimumDate = minDate
//        datePicker.maximumDate = maxDate
        showDatePicker()
    }
    

}

extension SettingView{
    class func settingView() -> SettingView{
        return Bundle.main.loadNibNamed("SettingView", owner: nil, options: nil)?.first as! SettingView
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textDatePicker.inputAccessoryView = toolbar
        textDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        textDatePicker.text = formatter.string(from: datePicker.date)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
}
