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
        home.tabBarItem = UITabBarItem(title: "速配", image: UIImage(named: "ico_love"), selectedImage: UIImage(named: "ico_love_sel"))
        let search = YRSearchViewController()
        search.tabBarItem = UITabBarItem(title: "找朋友", image: UIImage(named: "ico_friend"), selectedImage: UIImage(named: "ico_friend_sel"))
        
        let message = YRMessageViewController()
        message.tabBarItem = UITabBarItem(title: "速配", image: UIImage(named: "ico_dialogue"), selectedImage: UIImage(named: "ico_dialogue_sel"))
//        message.tabBarItem.badgeValue = ""
        
        let profile = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("Profile")
        profile.tabBarItem = UITabBarItem(title: "速配", image: UIImage(named: "ico_my"), selectedImage: UIImage(named: "ico_my_sel"))
        
        let controllersArr = [home, search, message, profile]
        var nvgArr:[UINavigationController] = []
        for item in controllersArr {
            let nvg = UINavigationController(rootViewController: item)
            nvg.navigationBar.shadowImage = UIImage()
            nvgArr.append(nvg)
        }

        viewControllers = nvgArr
    }

}
