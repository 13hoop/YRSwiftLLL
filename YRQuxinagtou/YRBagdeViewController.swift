//
//  YRBagdeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/9/28.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRBagdeViewController: UIViewController {

    var badge: Badge?
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var infoLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = badge else { return }
        print(model)
        
        if let name = model.name {
            nameLb.text = name
        }
        iconImgV.kf_showIndicatorWhenLoading = true
        if let urlStr = model.icon {
            iconImgV.kf_setImageWithURL(NSURL(string: urlStr))
        }
        if let info = model.name {
            infoLb.text = info
        }
    }
    
    @IBAction func closeBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func goAuthBtnClicked(sender: AnyObject) {
        
    }
}
