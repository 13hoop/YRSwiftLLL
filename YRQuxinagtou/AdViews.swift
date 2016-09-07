//
//  AdViews.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/26.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class AdView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .grayColor()
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        
        addSubview(adTapBtn)
        addSubview(adLabel)
        
        let viewsDict = ["adTapBtn" : adTapBtn, "adLabel" : adLabel]
        let vflDict = ["H:|-0-[adTapBtn]-4-[adLabel(80)]-0-|",
                       "V:|[adTapBtn]|",
                       "V:|[adLabel]|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private let adLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "推广功能"
        label.userInteractionEnabled = false
        label.backgroundColor = .clearColor()
        label.font = UIFont.systemFontOfSize(13.0)
        label.textColor = .yellowColor()
        label.textAlignment = .Left
        return label
    }()
    
    lazy var adTapBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
//        let attr = NSMutableAttributedString(string: "想让更多同城会员优先看到你么？不妨试试强大的 推广功能")
//        let attrDict1 = [
//            NSUnderlineStyleAttributeName : 1,
//            NSForegroundColorAttributeName : UIColor.yellowColor(),
//            NSStrokeWidthAttributeName : 3.0,
//            NSTextEffectAttributeName : NSTextEffectLetterpressStyle]
//        let attrDict2 = [
//            NSFontAttributeName : UIFont.systemFontOfSize(11.0),
//            NSForegroundColorAttributeName : UIColor.yellowColor(),
//            NSStrokeWidthAttributeName : 1.0,
//            NSTextEffectAttributeName : NSTextEffectLetterpressStyle]
//        attr.addAttributes(attrDict1, range: NSMakeRange(23, 4))
//        attr.addAttributes(attrDict2, range: NSMakeRange(0, 23))
//        view.setAttributedTitle(attr, forState: .Normal)
//        view.setAttributedTitle(attr, forState: .Highlighted)
        view.userInteractionEnabled = false
        view.setTitleColor(.yellowColor(), forState: .Normal)
        view.setTitle("想让更多同城会员优先看到你么？不妨试试强大的", forState: .Normal)
        view.setTitle("想让更多同城会员优先看到你么？不妨试试强大的", forState: .Highlighted)
        view.titleLabel?.font = UIFont.systemFontOfSize(11.0)
        view.contentHorizontalAlignment = .Right
        return view
    }()
}
