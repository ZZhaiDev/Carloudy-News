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
    @IBOutlet weak var toDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -29, to: Date())
        datePicker.maximumDate = Date()
        showDatePicker(textF: textDatePicker, tag: 0)
        showDatePicker(textF: toDatePicker, tag: 1)
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
    
    @objc func donedatePicker(sender: UITextField){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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
