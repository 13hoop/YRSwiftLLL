//
//  YRCustomTabbarController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRCustomTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewControllers()
    }
    
    func addSubviewControllers() {
    
        let home = YRHomeViewController()
        home.title = "速配"
        let search = YRSearchViewController()
        search.title = "搜索"
        let message = YRMessageViewController()
        message.title = "消息"
        let contact = YRContactViewController()
        contact.title = "联系人"
        let profile = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("Profile")
        profile.title = "我的"
        
        let controllersArr = [home, search, message, contact, profile]
        var nvgArr:[UINavigationController] = []
        for item in controllersArr {
            let nvg = UINavigationController(rootViewController: item)
            nvg.navigationBar.shadowImage = UIImage()
            nvgArr.append(nvg)
        }

        viewControllers = nvgArr
    }

}
