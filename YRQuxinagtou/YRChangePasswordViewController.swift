//
//  YRChangePasswordViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRChangePasswordViewController: UIViewController {
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        doneBtn.backgroundColor = YRConfig.disabledColored
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKeyBoard))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.whiteColor()
        passwordTF.addTarget(self, action: #selector(self.textFdChanged(_:)), forControlEvents: .EditingChanged)

    }
    @IBAction func doneBtnAction(sender: UIButton) {
        guard passwordTF.text?.characters.count > 6 else {
            errorLb.text = "密码至少为6位且不可使用空格"
            return
        }
        
        let dict = ["password" : passwordTF.text!]
        YRProgressHUD.showActivityIndicator()
        YRService.updateProfile(params: dict, success: { [weak self] (result) in
            YRProgressHUD.hideActivityIndicator()
            if let metaData = result {
                if let _ = metaData["errors"] {
                        self?.errorLb.text = "密码设置不符合要求，请重试"
                }else {
                    let vc = YRCustomTabbarController()
                    self?.presentViewController(vc, animated: true, completion: nil)
                }
            }
        }, fail: { error in
            YRProgressHUD.hideActivityIndicator()
            YRAlertHelp.showAutoAlert(time: 1.0, title: "警告", message: "请检查电话号码，重试", inViewController: self)
        })
    }
    
    func textFdChanged(textField : UITextField) {
    }
    
    func hiddenKeyBoard() {
        view.endEditing(true)
        doneBtn.backgroundColor = YRConfig.themeTintColored
        doneBtn.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordTF {
            hiddenKeyBoard()
        }
        return true
    }
}
