//
//  YRHeaderView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHeaderView: UIView {
    
    var backImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  UIColor.randomColor()
        setUpViews()
    }
    
    private func setUpViews() {
        
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.image = UIImage(named: "Profile_info_halfCircle")
        backImgV.addSubview(imgV)
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 50.0
        btn.setImage(UIImage(named: "demoAlbum"), forState: .Normal)
        btn.setImage(UIImage(named: "demoAlbum"), forState: .Highlighted)
        backImgV.addSubview(btn)

//        let vvv = UIView()
//        vvv.translatesAutoresizingMaskIntoConstraints = false
//        backImgV.addSubview(vvv)

        addSubview(backImgV)
        
        backImgV.image = UIImage(named: "demoAlbum")!.applyBlurWithRadius(5, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
        
        let viewsDict = ["backImgV" : backImgV,
                         "imgV" : imgV,
                         "btn" : btn,
        ]
        let vflDict = ["H:|-0-[backImgV]-0-|",
                       "V:|-0-[backImgV]-0-|",
                       "H:|-0-[imgV]-0-|",
                       "V:[imgV(150)]-0-|",
                       "H:[btn(100)]",
                       "V:[btn(100)]"
        ]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraint(NSLayoutConstraint(item: backImgV, attribute: .CenterX, relatedBy: .Equal, toItem: btn, attribute: .CenterX, multiplier: 1.0, constant: 0))
        backImgV.addConstraint(NSLayoutConstraint(item: backImgV, attribute: .CenterY, relatedBy: .Equal, toItem: btn, attribute: .CenterY, multiplier: 1.0, constant: -30.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//private class
