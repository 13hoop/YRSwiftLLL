//
//  YRDetailIfnoView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRDetailIfnoView: UIView {
    
    var collectionView: UICollectionView
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect) {

        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(UnitViewCell.self, forCellWithReuseIdentifier: "UnitViewCell")
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        let titleLb = UILabel()
        titleLb.text = "当前位置"
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        let editeBtn = UIButton()
        editeBtn.translatesAutoresizingMaskIntoConstraints = false
        editeBtn.contentHorizontalAlignment = .Right
        editeBtn.setTitle("编辑", forState: .Normal)
        editeBtn.setTitleColor(.blueColor(), forState: .Normal)
        
        // ------------------------------------------------------------------------
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let discriptionLb = UILabel()
        discriptionLb.numberOfLines = 2
        discriptionLb.textAlignment = .Left
        discriptionLb.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(discriptionLb)
        
        // collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        // Debug
        discriptionLb.text = "煞风景啊叫佳佳级啊就是发酒疯了啊交流交流交流了解了叫佳佳了解了就离开尽量加快了就了，大多数发生放大舒服"
        
        addSubview(imgV)
        addSubview(titleLb)
        addSubview(editeBtn)
        addSubview(contentView)
        
        let viewsDict = ["imgV" : imgV,
                         "titleLb" : titleLb,
                         "editeBtn" : editeBtn,
                         "contentView" : contentView,
                         "discriptionLb" : discriptionLb,
                         "collectionView" : collectionView]
        let vflDict = ["H:|-[imgV(20)]-[titleLb(100)]-[editeBtn]-|",
                       "V:|-[imgV(30)]-[contentView]",
                       "H:|-[contentView]-|",
                       
                       "V:|-[discriptionLb]-[collectionView(totleHeight)]-|",
                       "H:|-(28)-[discriptionLb]-|"
        ]
        
        let totleHeight = 5 * 40
        let metrics = ["totleHeight" : totleHeight]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        
        layoutIfNeeded()
        
        // layer
        let leftLayer = CALayer()
        leftLayer.frame = CGRectMake(10, 0, 1, contentView.frame.height)
        leftLayer.backgroundColor = UIColor.blackColor().CGColor
        contentView.layer.addSublayer(leftLayer)
        
        // layout
        layout.itemSize = CGSizeMake(collectionView.frame.width, 40)
        layout.minimumLineSpacing = 0.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnitViewCell: UICollectionViewCell {
    
    var titleLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var infoLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        let vflDict = ["H:|-0-[titleLb]-[infoLb]-0-|",
                       "V:|-[titleLb]-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

