//
//  YRLogInViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/17.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRLogInViewController: UIViewController {
    
    let accountTF: UITextField = {
        let view = UITextField(frame: CGRectZero)
        view.borderStyle = .RoundedRect
        view.placeholder = "账号"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTF: UITextField = {
        let view = UITextField(frame: CGRectZero)
        view.borderStyle = .RoundedRect
        view.placeholder = "密码"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var loginBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.setTitle("登陆", forState: .Normal)
        view.backgroundColor = YRConfig.systemTintColored
        view.addTarget(self, action: #selector(loginBtnClicked(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var userABtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.tag = 100
        view.setTitle("userA", forState: .Normal)
        view.backgroundColor = YRConfig.systemTintColored
        view.addTarget(self, action: #selector(loginBtnClicked(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userBBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.tag = 101
        view.setTitle("userB", forState: .Normal)
        view.backgroundColor = YRConfig.systemTintColored
        view.addTarget(self, action: #selector(loginBtnClicked(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setUpViews()
    }
    
    private func setUpViews() {

        view.addSubview(accountTF)
        view.addSubview(passwordTF)
        view.addSubview(loginBtn)
        
        view.addSubview(userABtn)
        view.addSubview(userBBtn)
        let viewsDict = ["accountTF" : accountTF,
                         "passwordTF" : passwordTF,
                         "loginBtn" : loginBtn,
                         "userABtn" : userABtn,
                         "userBBtn" : userBBtn,
                         ]
        let vflDict = ["H:|-50-[accountTF]-50-|",
                       "H:[passwordTF(accountTF)]",
                       "H:[loginBtn(accountTF)]",
                       "H:[userABtn(accountTF)]",
                       "H:[userBBtn(accountTF)]",
                       "V:|-130-[accountTF(44)]-[passwordTF(44)]-20-[loginBtn(40)]-[userABtn]-[userBBtn]"]
        view.addConstraint(NSLayoutConstraint(item: accountTF, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: .AlignAllCenterX, metrics: nil, views: viewsDict))
    }
    
    // MARK: Action
    func loginBtnClicked(sender: UIButton) {
        
        let accountText = accountTF.text!
        let passwordText = passwordTF.text!
        var body = [ " ": " "]
        body = ["mobile": accountText,
                    "password": passwordText]
        
        
        if sender.tag == 100{
            body = ["mobile": "18701377365",
                    "password": "12345678"]
        }else if sender.tag == 101{
            body = ["mobile": "13671108391",
                        "password": "12345678"]
        }
        
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
            
            // success
            let vc = YRCustomTabbarController()
            self?.presentViewController(vc, animated: true, completion: nil)
        }) { error in
            print("error here: \(error)")
        }
    }
}
