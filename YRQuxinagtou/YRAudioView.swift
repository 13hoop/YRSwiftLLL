//
//  YRAudioView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/5.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAudioView: UIView {
    
    // do not used, lazy forever ...
    lazy var imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var audioWave: YRAudioWave = {
        let view = YRAudioWave(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tipLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.text = "上滑取消录音"
        view.font = UIFont.systemFontOfSize(15.0)
        view.textColor = .redColor()
        view.textAlignment = .Center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var recordIndictor:YRRecordIndicatorView = {
        let view = YRRecordIndicatorView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        
        addSubview(recordIndictor)
        
        let viewsDict = [
               "recordIndictor" : recordIndictor]
        let vflDict = [
                       "H:[recordIndictor(120)]",
                       "V:|-[recordIndictor(120)]"]
        
        addConstraint(NSLayoutConstraint(item: recordIndictor, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class YRRecordIndicatorView: UIView {
    
    let imageView: UIImageView
    let textLabel: UILabel
    let images:[UIImage]
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.systemFontOfSize(13.0)
        textLabel.text = "手指上滑,取消发送"
        textLabel.textColor = UIColor.blackColor()
        
        images = [UIImage(named: "record_animate_01")!,
                  UIImage(named: "record_animate_02")!,
                  UIImage(named: "record_animate_03")!,
                  UIImage(named: "record_animate_04")!,
                  UIImage(named: "record_animate_05")!,
                  UIImage(named: "record_animate_06")!,
                  UIImage(named: "record_animate_07")!,
                  UIImage(named: "record_animate_08")!,
                  UIImage(named: "record_animate_09")!]
        
        imageView = UIImageView(frame: CGRectZero)
        imageView.image = images[0]
        
        super.init(frame: frame)
        backgroundColor = UIColor.hexStringColor(hex: "365560", alpha: 0.6)
        // 增加毛玻璃效果
        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualView.frame = self.bounds
        visualView.layer.cornerRadius = 10.0
        self.layer.cornerRadius = 10.0
        visualView.layer.masksToBounds = true
        
        addSubview(visualView)
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: -15))
        
        self.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: 10))
        self.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
        
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showText(text: String, textColor: UIColor = UIColor.blackColor()) {
        textLabel.textColor = textColor
        textLabel.text = text
    }
    
    func updateLevelMetra(levelMetra: Float) {
        if levelMetra > -20 {
            showMetraLevel(8)
        } else if levelMetra > -25 {
            showMetraLevel(7)
        }else if levelMetra > -30 {
            showMetraLevel(6)
        } else if levelMetra > -35 {
            showMetraLevel(5)
        } else if levelMetra > -40 {
            showMetraLevel(4)
        } else if levelMetra > -45 {
            showMetraLevel(3)
        } else if levelMetra > -50 {
            showMetraLevel(2)
        } else if levelMetra > -55 {
            showMetraLevel(1)
        } else if levelMetra > -60 {
            showMetraLevel(0)
        }
    }
    
    
    func showMetraLevel(level: Int) {
        if level > images.count {
            return
        }
        performSelectorOnMainThread(#selector(showIndicatorImage(_:)), withObject: NSNumber(integer: level), waitUntilDone: false)
    }
    
    func showIndicatorImage(level: NSNumber) {
        imageView.image = images[level.integerValue]
    }
}

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


