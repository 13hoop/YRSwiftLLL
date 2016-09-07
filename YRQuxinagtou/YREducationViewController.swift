//
//  YREducationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YREducationViewController: UIViewController {

    private var idImage: UIImage?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var marginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var schoolTextFd: UITextField!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationsKeyboard()
    }
    
    @IBAction func addPhotoAction(sender: AnyObject) {
        YRPhotoPicker.photoSinglePickerFromAlert(inViewController: self)
    }
    @IBAction func commitClicked(sender: AnyObject) {
        
        guard !self.activity.isAnimating() else { return }
        
        if let image = self.idImage {
            self.activity.hidden = false
            self.activity.startAnimating()
            
            if let mg = self.schoolTextFd.text {
                let updateData = ["school" : mg]
                YRService.authEducation(image: image, prama: updateData, success: { [weak self] _ in
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.photoBtn.setBackgroundImage(image, forState: .Normal)
                        self?.activity.stopAnimating()
                        YRAlertHelp.showAutoAlert(time: 1, title: "提示", message: "您的认证资料已提交，我们将尽快核实", inViewController: self, completion: { [weak self] in
                            self?.navigationController?.popViewControllerAnimated(true)
                            })
                    }
                    }, fail: { [weak self] _ in
                        self?.activity.stopAnimating()
                        YRAlertHelp.showAutoAlertCancel(title: "错误", message: "上传证件照失败，请检查网络稍后重试", cancelAction: nil, inViewController: self)
                    })
            } else {
                YRAlertHelp.showAutoAlertCancel(title: "提示", message: "请填写学校名称，然后再提交", cancelAction: nil, inViewController: self)
            }
        }
    }
    
    @IBAction func tapAction(sender: AnyObject) {
        self.schoolTextFd.resignFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension YREducationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func notificationsKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShowOrHide(notification: NSNotification) {
        if  let userInfo = notification.userInfo,
            endValue = userInfo[UIKeyboardFrameEndUserInfoKey],
            durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        {
            let endRect = endValue.CGRectValue
            let heightToMove = (notification.name == "UIKeyboardWillShowNotification") ? -endRect.height : 0
            
            self.marginTopConstraint.constant = heightToMove
            let duration = durationValue.doubleValue
            UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.commitBtn.userInteractionEnabled = true
        self.commitBtn.backgroundColor = YRConfig.themeTintColored
        return true
    }
}

extension YREducationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.idImage = image
        self.photoBtn.setBackgroundImage(image, forState: .Normal)
        self.commitBtn.userInteractionEnabled = true
    }
    
}
