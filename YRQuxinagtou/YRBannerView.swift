//
//  YRBannerView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/25.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRBannerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var leftFuncBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var rightFuncBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.text = "1/1"
        view.textColor = .whiteColor()
        view.font = UIFont.systemFontOfSize(14.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.registerClass(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.backgroundColor = .whiteColor()
        collectionView.pagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let backLable = UILabel()
        backLable.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        backLable.textAlignment = .Center
        backLable.font = UIFont.systemFontOfSize(15.0)
        backLable.textColor = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        collectionView.backgroundView = backLable
        return collectionView
    }()
    
    private func setUpViews() {
        
        let commentView = UIView()
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.addSubview(leftFuncBtn)
        commentView.addSubview(rightFuncBtn)
        commentView.addSubview(totalLb)
        
        addSubview(collectionView)
        addSubview(commentView)
        let viewsDict = ["collectionView" : collectionView,
                         "commentView" : commentView,
                         "rightFuncBtn" : rightFuncBtn,
                         "leftFuncBtn" : leftFuncBtn,
                         "totalLb" : totalLb]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|",
                       "H:|-0-[commentView]-0-|",
                       "V:[commentView(80)]-0-|",
                       
                       "H:[leftFuncBtn(60)]-40-[rightFuncBtn(leftFuncBtn)]",
                       "V:[leftFuncBtn(rightFuncBtn)]",
                       "V:[rightFuncBtn(60)]-|",
                       "V:[totalLb]-|",
                       "H:[totalLb(40)]-|",
        ]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        
        layoutIfNeeded()
        commentView.addConstraint(NSLayoutConstraint(item: rightFuncBtn, attribute: .CenterX, relatedBy: .Equal, toItem: commentView, attribute: .CenterX, multiplier: 1.0, constant: 50))
        commentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        commentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
        commentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[6] as String, options: [], metrics: nil, views: viewsDict))
        commentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[7] as String, options: [], metrics: nil, views: viewsDict))
        commentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[8] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class BannerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    var photoImgV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var activity: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        view.tintColor = YRConfig.themeTintColored
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    private func setUpViews() {
        
//        photoImgV.addSubview(activity)
        contentView.addSubview(photoImgV)
        
        let viewsDict = ["photoImgV" : photoImgV, "activity": activity]
        let vflDict = ["H:|-0-[photoImgV]-0-|",
                       "V:|-0-[photoImgV]-0-|"]
//        contentView.addConstraint(NSLayoutConstraint(item: activity, attribute: .CenterX, relatedBy: .Equal, toItem: photoImgV, attribute: .CenterX, multiplier: 1.0, constant: 0))
//        contentView.addConstraint(NSLayoutConstraint(item: activity, attribute: .CenterY, relatedBy: .Equal, toItem: photoImgV, attribute: .CenterY, multiplier: 1.0, constant: 0))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}