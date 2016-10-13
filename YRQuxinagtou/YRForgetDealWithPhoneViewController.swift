//
//  YRForgetDealWithPhoneViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRForgetDealWithPhoneViewController: UIViewController {

    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var requiredBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        requiredBtn.backgroundColor = YRConfig.disabledColored
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKeyBoard))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.whiteColor()
//        
        let psdTap = UITapGestureRecognizer(target: self, action: #selector(self.signNewUser(_:)))
        errorLb.addGestureRecognizer(psdTap)
        
        phoneTF.addTarget(self, action: #selector(self.phoneTFChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    // MARK: Action
    @IBAction func requiredBtnAction(sender: UIButton) {
        guard let phoneNum = phoneTF.text else {
            sender.enabled = false
            return
        }
        guard phoneTF.text?.characters.count == 11 else {
            errorLb.text = "输入正确的电话号码"
            errorLb.userInteractionEnabled = true
            return
        }
        
        let dict = ["type" : "find_password",
                    "mobile" : phoneNum]
        YRProgressHUD.showActivityIndicator()
        YRService.requireSMSCode(data: dict, success: { [weak self] result in
            YRProgressHUD.hideActivityIndicator()
            if let metaData = result {
                if let errors = metaData["errors"] {
                    guard errors != nil else {
                        YRUserDefaults.mobile = phoneNum
                        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterSMViewController") as! YRRegisterSMViewController
                        vc.isForgetPsd = true
                        self?.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                    self?.errorLb.text = "手机号与账户不匹配请重试，或者点击此处注册新用户"
                    self?.requiredBtn.backgroundColor = YRConfig.disabledColored
                }
            }
        }, fail: {[weak self] error in
                YRProgressHUD.hideActivityIndicator()
                self?.errorLb.text = "手机号与账户不匹配请重试，或者点击此处注册新用户"
        })
    }
    
    func phoneTFChanged(textField : UITextField) {
        if textField.text?.characters.count > 10 {
            let index = textField.text!.startIndex.advancedBy(10)
            print(textField.text!.substringToIndex(index))
            if textField == phoneTF {
                textField.resignFirstResponder()
                self.requiredBtn.backgroundColor = YRConfig.themeTintColored
            }
        }
    }
    
    func signNewUser(sender: UILabel) {
        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterViewController") as! YRRegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hiddenKeyBoard() {
        view.endEditing(true)
        requiredBtn.backgroundColor = YRConfig.themeTintColored
        requiredBtn.enabled = true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == phoneTF {
            hiddenKeyBoard()
        }
        return true
    }
}
