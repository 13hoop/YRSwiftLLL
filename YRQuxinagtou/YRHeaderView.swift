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
    var avateBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 50.0
        return btn
    }()
    var nameLb: UILabel = {
        let label = UILabel()
        label.text = "JASON"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var titleLb: UILabel = {
        let label = UILabel()
        label.text = "男， 25岁"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var completePercentLb: UILabel = {
        let label = UILabel()
        label.text = "资料完整度100%"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  UIColor.whiteColor()
        setUpViews()
    }
    
    private func setUpViews() {
        
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.image = UIImage(named: "Profile_info_halfCircle")
        backImgV.addSubview(imgV)
        
        let leftRateView = RateView()
        leftRateView.translatesAutoresizingMaskIntoConstraints = false
        backImgV.addSubview(leftRateView)

        let rightRateView = RateView()
        rightRateView.translatesAutoresizingMaskIntoConstraints = false
        backImgV.addSubview(rightRateView)
        
        // debuge
//        avateBtn.setImage(UIImage(named: "demoAlbum"), forState: .Normal)
//        avateBtn.setImage(UIImage(named: "demoAlbum"), forState: .Highlighted)
        
        backImgV.addSubview(avateBtn)
        backImgV.addSubview(nameLb)
        backImgV.addSubview(titleLb)
        backImgV.addSubview(completePercentLb)

        addSubview(backImgV)
        
        backImgV.image = UIImage(named: "demoAlbum")!.applyBlurWithRadius(5, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
        
        let viewsDict = ["backImgV" : backImgV,
                         "imgV" : imgV,
                         "btn" : avateBtn,
                         "nameLb" : nameLb,
                         "titleLb" : titleLb,
                         "completePercentLb" : completePercentLb,
                         "leftRateView" : leftRateView,
                         "rightRateView" : rightRateView,
        ]
        let vflDict = ["H:|-0-[backImgV]-0-|",
                       "V:|-0-[backImgV]-0-|",
                       "H:|-0-[imgV]-0-|",
                       "V:[imgV(150)]-0-|",
                       "H:[leftRateView(rateWidth)]-(34)-[btn(100)]-(34)-[rightRateView(leftRateView)]",
                       "V:[btn(100)]-[nameLb]-2-[titleLb]-2-[completePercentLb]",
                       "V:[leftRateView(rateHeight)]-30-|"
        ]
        let metrics = ["rateHeight": "100",
                       "rateWidth": "100"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: metrics, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: .AlignAllCenterX, metrics: nil, views: viewsDict))
        backImgV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[6] as String, options: [], metrics: metrics, views: viewsDict))
        backImgV.addConstraint(NSLayoutConstraint(item: backImgV, attribute: .CenterX, relatedBy: .Equal, toItem: avateBtn, attribute: .CenterX, multiplier: 1.0, constant: 0))
        backImgV.addConstraint(NSLayoutConstraint(item: backImgV, attribute: .CenterY, relatedBy: .Equal, toItem: avateBtn, attribute: .CenterY, multiplier: 1.0, constant: -30.0))
        backImgV.addConstraint(NSLayoutConstraint(item: leftRateView, attribute: .Bottom, relatedBy: .Equal, toItem: rightRateView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        backImgV.addConstraint(NSLayoutConstraint(item: leftRateView, attribute: .Height, relatedBy: .Equal, toItem: rightRateView, attribute: .Height, multiplier: 1.0, constant: 0.0))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class RateView: InfoBasic {
    
    var titleLb: UILabel = {
        let label = UILabel()
        label.text = "颜值"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var btn: UIButton = {
        let btn = UIButton()
        btn.titleLabel!.textAlignment = .Center
        btn.setTitle("提示颜值", forState: .Normal)
        btn.setTitleColor(UIColor.hexStringColor(hex: YRConfig.themeTintColor), forState: .Normal)
        btn.setTitleColor(UIColor.hexStringColor(hex: YRConfig.themeTintColor), forState: .Selected)
        btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var rateBtn: UICircleBtn = {
        let btn = UICircleBtn()
        btn.titleLabel!.textAlignment = .Center
        btn.setTitleColor(UIColor.hexStringColor(hex: YRConfig.themeTintColor), forState: .Normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func setUpViews() {
        
        rateBtn.setTitle("50%", forState: .Normal)
        
        addSubview(rateBtn)
        addSubview(titleLb)
        addSubview(btn)
        let viewsDict = ["btn" : btn,
                         "titleLb" : titleLb,
                         "rateBtn" : rateBtn]
        let vflDict = ["H:|-0-[rateBtn]-0-|",
                       "H:|-0-[titleLb]-0-|",
                       "H:|-0-[btn]-0-|",
                       "V:|-0-[rateBtn(50)]-0-[titleLb]-0-[btn]-0-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
    }
}

private class InfoBasic: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = UIColor.clearColor()
    }
    
    func setUpViews() {
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UICircleBtn: UIButton {
    override func drawRect(rect: CGRect) {
        let drawColor = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        print(self)
        let angle = CGFloat(M_PI_2)
        let path = UIBezierPath(arcCenter: self.center, radius: 20, startAngle: 0, endAngle: angle, clockwise: false)
        path.lineWidth = 2.0
        UIColor.whiteColor().setFill()
        drawColor!.setStroke()
        path.lineCapStyle = .Round
        path.lineJoinStyle = .Round
        path.fill()
        path.stroke()
    }
}

