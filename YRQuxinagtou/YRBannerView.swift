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
        addSubview(collectionView)
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class BannerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    var photoImgV: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var disLikeBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var likeBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private func setUpViews() {
        
        contentView.addSubview(photoImgV)
        contentView.addSubview(disLikeBtn)
        contentView.addSubview(likeBtn)
        
        disLikeBtn.backgroundColor = UIColor.randomColor()
        likeBtn.backgroundColor = UIColor.randomColor()
        
        let viewsDict = ["photoImgV" : photoImgV,
                         "disLikeBtn": disLikeBtn,
                         "likeBtn": likeBtn]
        let vflDict = ["H:|-0-[photoImgV]-0-|",
                       "V:|-0-[photoImgV]-0-|",
                       "H:[disLikeBtn(80)]-[likeBtn(disLikeBtn)]",
                       "V:[disLikeBtn(80)]-20-|",
                       "V:[likeBtn(disLikeBtn)]"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraint(NSLayoutConstraint(item: disLikeBtn, attribute: .CenterX, relatedBy: .Equal, toItem: photoImgV, attribute: .CenterX, multiplier: 1.0, constant: -45.0))
            
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}