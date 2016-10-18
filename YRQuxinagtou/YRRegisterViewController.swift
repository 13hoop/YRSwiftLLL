//
//  YRRegisterViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/21.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = YRConfig.plainBackgroundColored
        navigationController?.navigationBar.tintColor = YRConfig.themeTintColored
        sendBtn.backgroundColor = YRConfig.disabledColored
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKeyBoard))
        view.addGestureRecognizer(tap)
        sendBtn.enabled = false
        errorLb.text = ""
    }
    func hiddenKeyBoard() {
        view.endEditing(true)
        guard phoneTF.text?.characters.count > 0 else {
            self.sendBtn.backgroundColor = YRConfig.disabledColored
            return
        }
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
        
        guard phoneNum.characters.count == 11 else {
            errorLb.text = "请输入正确的电话号码"
            sender.backgroundColor = YRConfig.disabledColored
            return
        }
        
        let dict = ["type" : "sign_up",
                    "mobile" : phoneNum]
        YRUserDefaults.mobile = phoneNum

        YRProgressHUD.showActivityIndicator()
        YRService.requireSMSCode(data: dict, success: { [weak self] result in
            YRProgressHUD.hideActivityIndicator()
            if let metaData = result!["data"] as? String? {
                if let data = metaData {
                guard data == "ok" else {
                    self?.errorLb.text = "已有账户，无需重复注册，请返回上一页登陆"
                    self?.sendBtn.backgroundColor = YRConfig.disabledColored
                    let alertController: UIAlertController = UIAlertController(title: "提示", message: "此电话号码已注册，无需重复注册，请直接登陆", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "好的", style: .Cancel, handler: { (_) in
                        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("YRLogInViewController") as! YRLogInViewController
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                    alertController.addAction(action)
                    self?.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
        
                    let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterSMViewController") as! YRRegisterSMViewController
                    vc.isSignUp = true
                    self?.navigationController?.pushViewController(vc, animated: true)
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }, fail: { error in
            YRProgressHUD.hideActivityIndicator()
            YRAlertHelp.showAutoAlert(time: 1.0, title: "警告", message: "请检查电话号码，重试", inViewController: self)
        })
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendBtn.backgroundColor = YRConfig.themeTintColored
        sendBtn.enabled = true
        textField.resignFirstResponder()
        return true
    }
}
