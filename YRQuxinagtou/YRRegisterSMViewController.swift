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
        
        // reset
        defaultStatus()
        
        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterMaleViewController") as! YRRegisterMaleViewController
        navigationController?.pushViewController(vc, animated: true)
        
        YRUserDefaults.captcha = codeStr
        let dict = ["type": "sign_up",
                    "mobile": YRUserDefaults.mobile,
                    "captcha": codeStr]
        
        YRProgressHUD.showActivityIndicator()
        YRService.requireVerifidSMSCode(data: dict, success: { (result) in
            YRProgressHUD.hideActivityIndicator()
            
            }, fail: { error in
            YRProgressHUD.hideActivityIndicator()
        })
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
