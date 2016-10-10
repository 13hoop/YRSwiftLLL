//
//  YRRegisterSMViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/10.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterSMViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var oneLb: UILabel!
    @IBOutlet weak var twoLb: UILabel!
    @IBOutlet weak var threeLb: UILabel!
    @IBOutlet weak var fourLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YRConfig.plainBackgroundColored
        navigationController?.navigationBar.tintColor = YRConfig.themeTintColored
        textField.keyboardType = .NumberPad
        textField.becomeFirstResponder()
    }
    
    private func sendCodeAction() {
        
        let codeStr = oneLb.text! + twoLb.text! + threeLb.text! + fourLb.text!
        print(codeStr)

        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterMaleViewController") as! YRRegisterMaleViewController
        navigationController?.pushViewController(vc, animated: true)
        
//        let dict = ["": ]
//        YRProgressHUD.showActivityIndicator()
//        YRService.requireVerifidSMSCode(data: dict, success: { (result) in
//            YRProgressHUD.hideActivityIndicator()
//            
//            }, fail: { error in
//            YRProgressHUD.hideActivityIndicator()
//        })
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(" range:\(range) and Str is : \(string)")
        
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
