//
//  YRRealNameAuthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRealNameAuthViewController: UIViewController {

    private var idImage: UIImage?
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPhotoAction(sender: AnyObject) {
        YRPhotoPicker.photoSinglePickerFromAlert(inViewController: self)
    }
    
    @IBAction func commitClicked(sender: AnyObject) {
        guard !self.activity.isAnimating() else { return }
        if let image = self.idImage {
            self.activity.hidden = false
            self.activity.startAnimating()
            let imageData = UIImageJPEGRepresentation(image, 1.0)!
            YRService.authRealName(data: imageData, success: { [weak self] resule in
                dispatch_async(dispatch_get_main_queue()) {
                    self?.photoBtn.setBackgroundImage(image, forState: .Normal)
                    self?.activity.stopAnimating()                    
                    YRAlertHelp.showAutoAlert(time: 1, title: "提示", message: "您的认证资料已提交，我们将尽快核实", inViewController: self, completion: { [weak self] in
                        self?.navigationController?.popViewControllerAnimated(true)
                    })
                }
            }) { [weak self] error in
                self?.activity.stopAnimating()
                YRAlertHelp.showAutoAlertCancel(title: "错误", message: "上传证件照失败，请检查网络稍后重试", cancelAction: nil, inViewController: self)
            }
        }
    }
}

extension YRRealNameAuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }

        self.idImage = image
        self.photoBtn.setBackgroundImage(image, forState: .Normal)
        self.commitBtn.userInteractionEnabled = true
        self.commitBtn.backgroundColor = YRConfig.themeTintColored
    }
}