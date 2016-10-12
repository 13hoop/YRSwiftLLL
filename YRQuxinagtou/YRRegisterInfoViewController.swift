//
//  YRRegisterInfoViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/11.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var birthTF: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var pickerHeight: NSLayoutConstraint!
    private var avatarImageSelected: Bool = false
    private var avatarImage: UIImage?
    private var birthdaySelected: Bool = false
    private let errorDict = [
        "invalid captcha" : "短信验证码不正确",
        "invalid gender" : "选择的性别不对",
        "invalid purpose" : "选择的交友目的不对",
        "invalid want_gender" : "和谁选择的不对",
        "invalid age range" : "年龄范围选择的不对",
        "invalid birthday" : "生日选择的不对"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerHeight.constant = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hiddenKeyBoard))
        view.addGestureRecognizer(tap)
        errorLb.text = ""
        pickerView.addTarget(self, action: #selector(self.pickerAction(_:)), forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage.pureColor(UIColor.whiteColor()), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = YRConfig.systemTintColored
    }

    // action
    @IBAction func avatarBtnAction(sender: AnyObject) {
        // avatar
        YRPhotoPicker.photoSinglePickerFromAlert(inViewController: self)
    }
    
    @IBAction func doneAction(sender: AnyObject) {

        print(#function)
        
        guard self.avatarImageSelected else {
            errorLb.text = "请上传图像"
            return
        }
        
        guard nickNameTF.text != nil else {
            errorLb.text = "请填写昵称"
            return
        }
        
        guard birthdaySelected else {
            errorLb.text = "请选择生日"
            return
        }
        
        YRUserDefaults.userNickname = nickNameTF.text!
        YRUserDefaults.birthday = birthTF.text!
        
        let prama = ["mobile" : YRUserDefaults.mobile,
                     "captcha" : YRUserDefaults.captcha,
                     "gender" : YRUserDefaults.gender,
                     "purpose" : YRUserDefaults.purpose,
                     "want_gender" : YRUserDefaults.want_gender,
                     "age_min" : YRUserDefaults.age_min,
                     "age_max" : YRUserDefaults.age_max,
                     "nickname" : YRUserDefaults.userNickname,
                     "birthday" : YRUserDefaults.birthday]
        
        if let image = self.avatarImage {
            YRProgressHUD.showActivityIndicator()
            YRService.registerUser(image: image, prama: prama, success: { [weak self] result in
                YRProgressHUD.hideActivityIndicator()
                if let metaData = result {
                    
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
                        
                        let vc = YRCustomTabbarController()
                        self?.presentViewController(vc, animated: true, completion: nil)
                    }
                    
                    if let errors = metaData["errors"] {
                        guard errors != nil else { return }
                        let codeKey = errors["code"] as! String
                        self?.errorLb.text = self?.errorDict[codeKey]
                    }
                }
            }, fail: { [weak self] error in
                YRProgressHUD.hideActivityIndicator()
                self?.errorLb.text = "网络无连接，请稍后重试！"
            })
        }
    }
    
    func pickerAction(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFromString("yyyy-MM-dd")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(sender.date)
        birthdaySelected = true
        print(" -----> \(dateString)")
        birthTF.text = dateString
    }
    
    func hiddenKeyBoard() {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        guard textField.tag != 111 else {
            hiddenKeyBoard()
            UIView.animateWithDuration(1.0, animations: {
                self.pickerHeight.constant = 150.0
                self.view.layoutIfNeeded()
            })
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension YRRegisterInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        self.avatarImageSelected = true
        self.avatarImage = image
        self.avatarBtn.setBackgroundImage(image, forState: .Normal)
    }
}

