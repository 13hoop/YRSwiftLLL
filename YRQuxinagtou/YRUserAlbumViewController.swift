//
//  YRUserAlbumViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRUserAlbumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "相册"
        view.backgroundColor = UIColor.randomColor()
        hidesBottomBarWhenPushed = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
