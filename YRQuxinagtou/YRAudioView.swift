//
//  YRAudioView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/5.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAudioWave: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YRAudioView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        addSubview(imgV)
        addSubview(tipLb)
        addSubview(audioWave)
        
        // debuge
        imgV.backgroundColor = UIColor.randomColor()
        audioWave.backgroundColor = UIColor.randomColor()
        
        let viewsDict = ["imgV" : imgV,
                         "audioWave" : audioWave,
                         "tipLb" : tipLb]
        let vflDict = ["H:|-[tipLb]-|",
                       "H:[imgV(40)]",
                       "V:[imgV(25)]-10-[tipLb]",
                       "V:[tipLb]-20-|",
                       "H:|[audioWave]|",
                       "V:|-[audioWave(100)]"]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllCenterX, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let audioWave: YRAudioWave = {
        let view = YRAudioWave(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tipLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.text = "上滑取消录音"
        view.font = UIFont.systemFontOfSize(15.0)
        view.textColor = .redColor()
        view.textAlignment = .Center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
