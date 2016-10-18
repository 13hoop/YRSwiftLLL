//
//  YRRegisterSMViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/10.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterSMViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var oneLb: UILabel!
    @IBOutlet weak var twoLb: UILabel!
    @IBOutlet weak var threeLb: UILabel!
    @IBOutlet weak var fourLb: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    
    var isForgetPsd: Bool = false
    var isSignUp: Bool = false
    var isSignIn: Bool = false
    private let errorDict = ["invalid mobile" : "无效的手机号",
                             "empty type" : "未提供请求类型, 标识验证码的用途",
                     "already registered" : "该用户已经注册过, 仅当请求注册验证码时",
                     "invalid captcha" : "验证码输入错误"]
    lazy var assistedTextField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.keyboardAppearance = .Dark
        view.keyboardType = .NumberPad
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLb.text = ""
        view.addSubview(assistedTextField)
        navigationController?.navigationBar.tintColor = YRConfig.themeTintColored
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        assistedTextField.text = nil
        assistedTextField.becomeFirstResponder()
        navigationController?.navigationBar.setBackgroundImage(UIImage.pureColor(UIColor.whiteColor()), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = YRConfig.systemTintColored
        
        oneLb.layer.borderWidth = 1
        twoLb.layer.borderWidth = 1
        threeLb.layer.borderWidth = 1
        fourLb.layer.borderWidth = 1
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.assistedTextField.resignFirstResponder()
    }
    
    private func sendCodeAction() {
        let codeStr = oneLb.text! + twoLb.text! + threeLb.text! + fourLb.text!
        print(codeStr)
        print("text field is: \(assistedTextField.text)")

        guard codeStr.characters.count == 4 else {
            errorLb.text = "请重新输入验证码"
            assistedTextField.text = nil
            return
        }
        
        YRUserDefaults.captcha = codeStr
        
        var dict:[String : String] = [:]
        if isSignIn {
            dict["type"] = "sign_in"
        }else if isSignUp {
            dict["type"] = "sign_up"
        }else if isForgetPsd {
            dict["type"] = "find_password"
        }
            
        dict["mobile"] = YRUserDefaults.mobile
        dict["captcha"] = codeStr
        
        YRProgressHUD.showActivityIndicator()
        YRService.requireVerifidSMSCode(data: dict, success: { [weak self] (result) in
            YRProgressHUD.hideActivityIndicator()
            self?.nextSetp(result)
        }, fail: { error in
            YRProgressHUD.hideActivityIndicator()
            
        })
    }
    
    private func nextSetp(info : AnyObject?) {
        
        if isSignIn {
            
        }else if isSignUp {
            if let metaData = info {
                if let errors = metaData["errors"] {
                    if errors != nil {
                        let codeKey = errors["code"] as! String
                        defaultStatus()
                        self.errorLb.text = self.errorDict[codeKey]
                    }
                }
                
                if let data = metaData["data"] {
                    if data != nil {
                        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterMaleViewController") as! YRRegisterMaleViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }else if isForgetPsd {
            
            if let metaData = info {
                
                if let errors = metaData["errors"] {
                    if errors != nil {
                        let codeKey = errors["code"] as! String
                        self.errorLb.text = self.errorDict[codeKey]
                    }
                }
                
                if let data = metaData["data"] {
                    guard data != nil else { return }
                    let auth_token: String = data["auth_token"] as! String
                    let uuidStr: String = data["uuid"] as! String
                    //                        print(auth_token)
                    //                        print(uuid)
                    YRUserDefaults.userAuthToken = auth_token
                    YRUserDefaults.userUuid = uuidStr
                    let token = auth_token
                    let name = YRUserDefaults.userNickname
                    let uuid = uuidStr
                    let avater = ""
                    let userInfo = LoginUser(accessToken: token, nickname: name, uuid: uuid, avatarURLString: avater)
                    YRService.saveTokenAndUserInfoOfLoginUser(userInfo)
                    defaultStatus()
                    let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("YRChangePasswordViewController") as! YRChangePasswordViewController
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func recenrSMSCodeAction(sender: AnyObject) {
        print(#function)

    }
    
    
    private func defaultStatus() {
        assistedTextField.text = nil
        oneLb.text = nil
        twoLb.text = nil
        threeLb.text = nil
        fourLb.text = nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        // bebug
//        print(" range:\(range) and Str is : \(string)")
//        print(" -- text field is: \(textField.text)   and length \(textField.text?.characters.count)")
        
        switch range.location {
        case 0:
            oneLb.text = string
        case 1:
            twoLb.text = string
        case 2:
            threeLb.text = string
        case 3:
            fourLb.text = string
            self.sendCodeAction()
        default:
            return false
        }
        return true
    }
}
