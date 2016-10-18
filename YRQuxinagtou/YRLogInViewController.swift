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
    @IBOutlet weak var forgetPsdBtn: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var showPsdImg: UIImageView!

    private let errorDict = ["user not exist" : "用户不存在,可以点击此处注册",
                             "wrong password" : "密码错误",
                             "wrong captcha" : "验证码错误",
                             "forbidden login" : "禁止登录, 登录失败次数过多(1小时后再试)"]
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
        forgetPsdBtn.addGestureRecognizer(psdTap)
        
        let errorTap = UITapGestureRecognizer(target: self, action: #selector(self.signNewUser(_:)))
        errorLb.addGestureRecognizer(errorTap)

        let showPsd = UITapGestureRecognizer(target: self, action: #selector(self.showPsd(_:)))
        showPsdImg.addGestureRecognizer(showPsd)

        phoneTF.addTarget(self, action: #selector(self.phoneTFChanged(_:)), forControlEvents: .EditingChanged)
        
        logInBtn.backgroundColor = YRConfig.disabledColored
    }
    
    // MARK: Action
    func hiddenKeyBoard() {
        view.endEditing(true)
        
        guard phoneTF.text?.characters.count > 0 else {
            logInBtn.backgroundColor = YRConfig.disabledColored
            return
        }
        
        guard passwordTF.text?.characters.count > 0 else {
            logInBtn.backgroundColor = YRConfig.disabledColored
            return
        }
        logInBtn.backgroundColor = YRConfig.themeTintColored
        logInBtn.enabled = true
    }
    
    func signNewUser(sender: UILabel) {
        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterViewController") as! YRRegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func forgetPwdAction() {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("YRForgetDealWithPhoneViewController") as! YRForgetDealWithPhoneViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        guard phoneTF.text?.characters.count == 11 else {
            errorLb.text = "请输入正确的电话号码"
            return
        }
        guard passwordTF.text?.characters.count > 0 else {
            errorLb.text = "登陆必须输入密码"
            return
        }
        
        let body = ["mobile": phoneTF.text!,
                "password": passwordTF.text!]
        YRProgressHUD.showActivityIndicator()
        YRService.requireLogIn(user: body, success: {[weak self] results in
            YRProgressHUD.hideActivityIndicator()
            if let metaData = results {
                
                if let errors = metaData["errors"] {
                    if errors != nil {
                        let codeKey = errors["code"] as! String
                        self?.errorLb.text = self?.errorDict[codeKey]
                        if codeKey == "user not exist" {
                            self?.errorLb.userInteractionEnabled = true
                        }else {
                            self?.errorLb.userInteractionEnabled = false
                        }
                    }
                }
                
                if let data = metaData["data"] {
                    guard data != nil else { return }
                    let token = data!["auth_token"] as! String
                    let uuid = data!["uuid"] as! String
                    let userInfo = LoginUser(accessToken: token, nickname: "", uuid: uuid, avatarURLString: "")
                    YRService.saveTokenAndUserInfoOfLoginUser(userInfo)
                    let vc = YRCustomTabbarController()
                    self?.presentViewController(vc, animated: true, completion: nil)
                }
            }
        }) { error in
            YRProgressHUD.hideActivityIndicator()
            print("error here: \(error)")
        }
    }
    
    func showPsd(sender: UIImageView) {
        guard passwordTF.text?.characters.count > 0 else {
            return
        }
        passwordTF.secureTextEntry = !passwordTF.secureTextEntry
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
    
    // bebug
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

}
