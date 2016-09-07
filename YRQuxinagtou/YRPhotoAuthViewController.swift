//
//  YRPhotoAuthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRPhotoAuthViewController: UIViewController {

    private var idImage: UIImage?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var commitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePhotoClicked(sender: AnyObject) {
        
        if self.commitBtn.selected {
            guard !self.activity.isAnimating() else { return }
            if let image = self.idImage {
                self.activity.hidden = false
                self.activity.startAnimating()
                let imageData = UIImageJPEGRepresentation(image, 1.0)!
                YRService.authPhoto(data: imageData, success: { [weak self] resule in
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.imgView.image = image
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
        }else {
            YRPhotoPicker.takePhotoAlert(inViewController: self)
        }
    }
}

extension YRPhotoAuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }

        self.idImage = image
        self.imgView.image = image
        self.commitBtn.selected = true
    }
}

