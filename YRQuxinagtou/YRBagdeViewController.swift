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
    @IBOutlet weak var goAuthBtn: UIButton!
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
        if let intro = model.intro {
            infoLb.text = intro
        }
        
        // car and hourse
        if let id = model.id {
            if id == "2" || id == "6" {
                if let earnedStr = model.earned {
                    goAuthBtn.hidden = earnedStr == "no" ? false : true
                }
            }else {
                goAuthBtn.hidden = true
            }
        }
    }
    
    @IBAction func closeBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func goAuthBtnClicked(sender: AnyObject) {
        guard let model = badge else { return }
        if let id = model.id {
            switch id {
            case "1":
                let vc = UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YRCatAuthViewController") as! YRCatAuthViewController
                navigationController?.pushViewController(vc, animated: true)
            case "6":
                let vc =  UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YRHouseAuthViewController") as! YRHouseAuthViewController
                navigationController?.pushViewController(vc, animated: true)
            default:
                return
            }
        }
    }
}
