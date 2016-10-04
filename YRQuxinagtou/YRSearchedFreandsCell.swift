//
//  YRSearchedFreandsCell.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/9/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRSearchedFreandsCell: UICollectionViewCell {
    let nameLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont.systemFontOfSize(11.0)
        view.textAlignment = .Center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let avaterImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let onlinImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true
        return view
    }()
    let connectionImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let certificatedImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        // debug
        avaterImgV.backgroundColor = UIColor.randomColor()
        certificatedImgV.backgroundColor = UIColor.randomColor()
        connectionImgV.backgroundColor = UIColor.randomColor()
        onlinImgV.backgroundColor = UIColor.greenColor()
        nameLb.text = "JASON"
        
        contentView.addSubview(avaterImgV)
        contentView.addSubview(nameLb)
        contentView.addSubview(certificatedImgV)
        contentView.addSubview(onlinImgV)
        contentView.addSubview(connectionImgV)
        
        
        let viewsDict = ["avaterImgV" : avaterImgV,
                         "onlinImgV" : onlinImgV,
                         "connectionImgV" : connectionImgV,
                         "certificatedImgV" : certificatedImgV,
                         "nameLb" : nameLb]
        
        let vflDict = ["H:|-0-[avaterImgV]-0-|",
                       "V:|-0-[avaterImgV]-0-[nameLb]|",
                       "H:[connectionImgV(14)]-5-[nameLb]-5-[onlinImgV(12)]",
                       "H:[certificatedImgV(40)]",
                       "V:[certificatedImgV(40)]"]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllCenterX, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraint(NSLayoutConstraint(item: avaterImgV, attribute: .Width, relatedBy: .Equal, toItem: avaterImgV, attribute: .Height, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: connectionImgV, attribute: .Width, relatedBy: .Equal, toItem: connectionImgV, attribute: .Height, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: onlinImgV, attribute: .Width, relatedBy: .Equal, toItem: onlinImgV, attribute: .Height, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avaterImgV, attribute: .CenterX, relatedBy: .Equal, toItem: certificatedImgV, attribute: .CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avaterImgV, attribute: .Bottom, relatedBy: .Equal, toItem: certificatedImgV, attribute: .Bottom, multiplier: 1.0, constant: 0))
        contentView.layoutIfNeeded()
        let avaterImgWidth = avaterImgV.bounds.width
        avaterImgV.layer.cornerRadius = avaterImgWidth / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
