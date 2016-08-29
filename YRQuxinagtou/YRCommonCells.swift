//
//  YRCommonCells.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/28.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

// MARK:--------- collection view cells -----------
class AuthTagCell: YRInsigiaViewBasicCell {
    
    let titleLb: UILabel = {
        let label = UILabel()
        label.text = "照片认证"
        label.backgroundColor = UIColor.hexStringColor(hex: YRConfig.authTagColor)
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.hexStringColor(hex: YRConfig.authTagColor)?.CGColor
        label.font = UIFont.systemFontOfSize(15.0)
        label.layer.borderWidth = 0.5
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func setUpViews() {
        contentView.addSubview(titleLb)
        let viewsDict = ["titleLb" : titleLb]
        let vflDict = [
                       "H:|[titleLb]|",
                       "V:|[titleLb]|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class AuthCell: YRInsigiaViewBasicCell {
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    let titleLb: UILabel = {
        let label = UILabel()
        label.text = "照片"
        label.font = UIFont.systemFontOfSize(14.0)
        label.layer.borderWidth = 0.5
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        btn.setTitle("以认证", forState: .Selected)
        btn.setTitleColor(.blackColor(), forState: .Selected)
        btn.setTitle("去认证", forState: .Normal)
        btn.setTitleColor(UIColor.hexStringColor(hex: YRConfig.mainTextColor), forState: .Selected)
        btn.setTitle("审核中..", forState: .Highlighted)
        btn.setTitleColor(UIColor.hexStringColor(hex: YRConfig.mainTextColor), forState: .Selected)
        return btn
    }()
    
    override func setUpViews() {
        
        backgroundColor = UIColor.randomColor()
        contentView.addSubview(imgV)
        contentView.addSubview(titleLb)
        contentView.addSubview(btn)
        
        let viewsDict = ["imgV" : imgV,
                         "titleLb" : titleLb,
                         "btn" : btn]
        let vflDict = ["H:[imgV(42)]",
                       "H:|-0-[titleLb]-0-|",
                       "H:|-0-[btn]-0-|",
                       "V:|-0-[imgV(42)]-2-[titleLb]-0-[btn]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: .AlignAllCenterX, metrics: nil, views: viewsDict))
    }
    
}

class InsigniaCell: YRInsigiaViewBasicCell {
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    let titleLb: UILabel = {
        let label = UILabel()
        label.text = "男神"
        label.textColor = YRConfig.mainTitleTextColored
        label.font = UIFont.systemFontOfSize(14.0)
        label.layer.borderWidth = 0.5
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        backgroundColor = UIColor.randomColor()
        
        contentView.addSubview(imgV)
        contentView.addSubview(titleLb)
        
        let viewsDict = ["imgV" : imgV,
                         "titleLb" : titleLb]
        let vflDict = ["H:|-0-[imgV]-0-|",
                       "H:|-0-[titleLb]-0-|",
                       "V:|-0-[imgV]-[titleLb]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRInsigiaViewBasicCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnitViewCell: UICollectionViewCell {
    
    var titleLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.mainTextColored
        label.contentMode = .ScaleAspectFit
        label.textAlignment = .Left
        return label
    }()
    
    var infoLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.mainTitleTextColored
        label.textAlignment = .Left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLb.text = "婚恋状态: "
        infoLb.text = "dans adfasfasfas xxxx"
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(titleLb)
        contentView.addSubview(infoLb)
        
        let viewsDict = ["titleLb" : titleLb,
                         "infoLb" : infoLb]
        let vflDict = ["H:|[titleLb(100)]-30-[infoLb]|",
                       "V:|-[titleLb]-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FlowUnitViewCell: UICollectionViewCell {
    
    var titleLb: UILabel = {
        let label = UILabel()
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.grayColor().CGColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        contentView.addSubview(titleLb)
        
        let viewsDict = ["titleLb" : titleLb]
        let vflDict = ["H:|-2-[titleLb]-2-|",
                       "V:|-4-[titleLb]-4-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:--------- tableview cells -----------

class InsigniaTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(insigniaView)
        let viewsDict = ["insigniaView" : insigniaView]
        let vflDict = ["H:|-0-[insigniaView]-0-|",
                       "V:|-0-[insigniaView]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        layoutIfNeeded()
    }
    
    let insigniaView: YRInsigniaView = {
        let insigniaView = YRInsigniaView()
        insigniaView.translatesAutoresizingMaskIntoConstraints = false
        return insigniaView
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK:--------- layout -----------
class FlowUnitLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElementsInRect(rect)
        
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        var leftMargin: CGFloat = 0.0
        
        for attributes in attributesForElementsInRect! {
            
            let refAttributes = attributes
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            }else {
                var newleftAligedFrame = refAttributes.frame
                newleftAligedFrame.origin.x = leftMargin
                refAttributes.frame = newleftAligedFrame
            }
            
            leftMargin += refAttributes.frame.size.width + 8
            // 必须要copy一次，否则不cache
            let ref = refAttributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesForElementsInRect.append(ref)
        }
        return attributesForElementsInRect
    }
}
