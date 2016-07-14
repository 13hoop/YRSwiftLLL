//
//  YRHomeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHomeViewController: UIViewController {


    let photoArr = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        loadData()
    }
    
    private func setUpViews() {
        
        view.backgroundColor = UIColor.randomColor()
    }
    
    private func loadData() {
        YRService.requireLogIn(success: { results in
            print("-- success here ---")
            if let data = results!["data"] {
                let token = data["auth_token"] as! String
                let name = data["nickname"] as! String
                let uuid = data["uuid"] as! String
                let userInfo = LoginUser(accessToken: token, nickname: name, uuid: uuid)
                YRService.saveTokenAndUserInfoOfLoginUser(userInfo)
            }
            
        }) { error in
            print("error here: \(error)")
        }
        
        
//        YRService.requireSMSCode(success: { 
//            print("  success here! ")
//            }) { 
//            print(" ~ error here ~ ")
//        }
    }

    
}
