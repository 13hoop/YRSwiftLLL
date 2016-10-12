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
        
//        let prama = ["mobile" : ,
//                     "" :
//        ]
        
//        YRProgressHUD.showActivityIndicator()
//        YRService.registerUser(image: avatarImage!, prama: <#T##[String : String]#>, success: { result in
//            YRProgressHUD.hideActivityIndicator()
//            
//            }, fail: { error in
//            YRProgressHUD.hideActivityIndicator()
//
//        })
    }
    
    func pickerAction(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFromString("yyyy-MM-dd")
        let dateString = dateFormatter.stringFromDate(sender.date)
        birthTF.text = dateString
        birthdaySelected = true
    }
    
    func hiddenKeyBoard() {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        guard textField.tag != 111 else {
            textField.endEditing(true)
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

