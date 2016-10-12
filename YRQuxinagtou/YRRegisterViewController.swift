//
//  YRRegisterViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/21.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = YRConfig.plainBackgroundColored
        navigationController?.navigationBar.tintColor = YRConfig.themeTintColored
        sendBtn.backgroundColor = YRConfig.mainTextColored
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKeyBoard))
        view.addGestureRecognizer(tap)
        sendBtn.enabled = false

    }
    func hiddenKeyBoard() {
        view.endEditing(true)
        sendBtn.backgroundColor = YRConfig.themeTintColored
        sendBtn.enabled = true
    }

    @IBAction func protocolTappedAction(sender: AnyObject) {
        print(#function)
    }
    
    @IBAction func sendBtnClicked(sender: UIButton) {
        guard let phoneNum = phoneTF.text else {
            sender.enabled = false
            return
        }
        
        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterSMViewController") as! YRRegisterSMViewController
        navigationController?.pushViewController(vc, animated: true)
        let dict = ["type" : "sign_up",
                    "mobile" : phoneNum]
        YRUserDefaults.mobile = phoneNum
//        YRProgressHUD.showActivityIndicator()
//        YRService.requireSMSCode(data: dict, success: { result in
//            // push next
//            YRProgressHUD.hideActivityIndicator()
//            
//        }, fail: { error in
//            YRProgressHUD.hideActivityIndicator()
//            YRAlertHelp.showAutoAlert(time: 1.0, title: "警告", message: "网络无链接，请检查后稍后重试", inViewController: self)
//        })
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendBtn.backgroundColor = YRConfig.themeTintColored
        sendBtn.enabled = true
        textField.resignFirstResponder()
        return true
    }
}
