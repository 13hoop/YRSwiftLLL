//
//  YRLogInViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/17.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRLogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var fogetPwdLb: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var errorLb: UILabel!
    let accountTF: UITextField = {
        let view = UITextField(frame: CGRectZero)
        view.borderStyle = .RoundedRect
        view.placeholder = "账号"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = YRConfig.themeTintColored
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKeyBoard))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.whiteColor()
        
        let psdTap = UITapGestureRecognizer(target: self, action: #selector(self.forgetPwdAction))
        fogetPwdLb.addGestureRecognizer(psdTap)
        
        phoneTF.addTarget(self, action: #selector(self.phoneTFChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    // MARK: Action
    func hiddenKeyBoard() {
        view.endEditing(true)
        logInBtn.backgroundColor = YRConfig.themeTintColored
        logInBtn.enabled = true
    }
    
    func forgetPwdAction() {
        print(#function)
    
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        guard phoneTF.text?.characters.count == 11 else {
            errorLb.text = "请检查电话号码"
            return
        }
        guard passwordTF.text?.characters.count > 0 else {
            errorLb.text = "登陆必须输入密码"
            return
        }
        
        let body = ["mobile": phoneTF.text!,
                "password": passwordTF.text!]
        YRService.requireLogIn(user: body, success: {[weak self] results in
            if let data = results!["data"] {
                let token = data!["auth_token"] as! String
                let uuid = data!["uuid"] as! String
                let userInfo = LoginUser(accessToken: token, nickname: "", uuid: uuid, avatarURLString: "")
                YRService.saveTokenAndUserInfoOfLoginUser(userInfo)
            }
            let vc = YRCustomTabbarController()
            self?.presentViewController(vc, animated: true, completion: nil)
        }) { error in
            print("error here: \(error)")
        }
    }
    
    func debugLoginAction() {
        var body = [ " ": " "]
//        if sender.tag == 100{
//            body = ["mobile": "18701377365",
//                    "password": "12345678"]
//        }else if sender.tag == 101{
//            body = ["mobile": "13671108391",
//                    "password": "12345678"]
//        }

        body = ["mobile": "13671108391",
                "password": "12345678"]

        // logIn
        YRService.requireLogIn(user: body, success: {[weak self] results in
            if let data = results!["data"] {
                let token = data!["auth_token"] as! String
                let name = data!["nickname"] as! String
                let uuid = data!["uuid"] as! String
                let avater = data!["avatar"] as! String
                let userInfo = LoginUser(accessToken: token, nickname: name, uuid: uuid, avatarURLString: avater)
                YRService.saveTokenAndUserInfoOfLoginUser(userInfo)
            }
            let vc = YRCustomTabbarController()
            self?.presentViewController(vc, animated: true, completion: nil)
        }) { error in
            print("error here: \(error)")
        }
    }

    func phoneTFChanged(textField : UITextField) {
        if textField.text?.characters.count > 10 {
            let index = textField.text!.startIndex.advancedBy(10)
            print(textField.text!.substringToIndex(index))
            
            if textField == phoneTF {
                textField.resignFirstResponder()
                passwordTF.becomeFirstResponder()
            }
        
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == phoneTF {
            textField.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        }else {
            hiddenKeyBoard()
        }
        return true
    }
}
