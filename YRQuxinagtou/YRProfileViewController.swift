//
//  YRProfileViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let item: UIBarButtonItem = UIBarButtonItem(title: "设置", style: .Plain, target: self, action: #selector(settingBtnClicked))
        navigationItem.rightBarButtonItem =  item
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func settingBtnClicked() {
        let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewControllerWithIdentifier("YRSetViewController")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
