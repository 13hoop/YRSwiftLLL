//
//  YRHouseAuthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHouseAuthViewController: UIViewController {

    private var mortgage: String?
    private var idImage: UIImage?
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!

    private var selected: Bool = false
    @IBOutlet weak var creditBtn: UIButton!
    @IBOutlet weak var noCreditBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func creditBtnClicked(sender: AnyObject) {
        self.commitBtn.backgroundColor =  YRConfig.themeTintColored
        self.noCreditBtn.selected = false
        self.mortgage = "have"
        guard !self.creditBtn.selected else { return }
        self.creditBtn.selected = !self.creditBtn.selected
    }
    @IBAction func noCreditBtnClicked(sender: AnyObject) {
        self.commitBtn.backgroundColor =  YRConfig.themeTintColored
        self.creditBtn.selected = false
        self.mortgage = "no"
        guard !self.noCreditBtn.selected else { return }
        self.noCreditBtn.selected = !self.noCreditBtn.selected
    }

    @IBAction func addPhotoAction(sender: AnyObject) {
        YRPhotoPicker.photoSinglePickerFromAlert(inViewController: self)
    }

    @IBAction func commitClicked(sender: AnyObject) {
        guard !self.activity.isAnimating() else { return }
        if let image = self.idImage {
            self.activity.hidden = false
            self.activity.startAnimating()

            if let mg = self.mortgage {
                let updateData = ["mortgage" : mg]
                YRService.authHouse(image: image, prama: updateData, success: { [weak self] _ in
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
                YRAlertHelp.showAutoAlertCancel(title: "提示", message: "请选取是否有房贷，然后再提交", cancelAction: nil, inViewController: self)
            }
        }
    }
}

extension YRHouseAuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.idImage = image
        self.photoBtn.setBackgroundImage(image, forState: .Normal)
        self.commitBtn.userInteractionEnabled = true
    }
    
}