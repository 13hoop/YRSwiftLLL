//
//  YRSearchViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        view.addSubview(collectionView)
        
        let itemWidth = (UIScreen.mainScreen().bounds.width - 40) / 3
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 20)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        layout.scrollDirection = .Vertical
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsetsMake(8.0, 8.0, 0, 8.0)
        collectionView.registerClass(YRSearchedFreandsCell.self, forCellWithReuseIdentifier: "YRSearchedFreandsCell")
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
}

extension YRSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRSearchedFreandsCell", forIndexPath: indexPath) as! YRSearchedFreandsCell
        return cell
    }
}

class YRSearchedFreandsCell: UICollectionViewCell {
    
    let nameLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont.systemFontOfSize(14.0)
        view.textAlignment = .Right
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let avaterImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let statusImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.0
        view.layer.masksToBounds = true
        return view
    }()
    let likeImgV: UIImageView = {
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
        likeImgV.backgroundColor = UIColor.randomColor()
        statusImgV.backgroundColor = UIColor.greenColor()
        nameLb.text = "JASON"
        
        contentView.addSubview(avaterImgV)
        contentView.addSubview(nameLb)
        contentView.addSubview(likeImgV)
        contentView.addSubview(statusImgV)
        
        let viewsDict = ["avaterImgV" : avaterImgV,
                         "statusImgV" : statusImgV,
                         "likeImgV" : likeImgV,
                         "nameLb" : nameLb]
        
        let vflDict = ["H:|-0-[avaterImgV]-0-|",
                       "V:|-0-[avaterImgV]-0-[nameLb]|",
                       "H:|-0-[nameLb]-5-[statusImgV(14)]-20-|",
                       "H:[likeImgV(40)]",
                       "V:[likeImgV(40)]"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraint(NSLayoutConstraint(item: avaterImgV, attribute: .Width, relatedBy: .Equal, toItem: avaterImgV, attribute: .Height, multiplier: 1.0, constant: 0))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraint(NSLayoutConstraint(item: statusImgV, attribute: .Width, relatedBy: .Equal, toItem: statusImgV, attribute: .Height, multiplier: 1.0, constant: 0))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraint(NSLayoutConstraint(item: avaterImgV, attribute: .Right, relatedBy: .Equal, toItem: likeImgV, attribute: .Right, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avaterImgV, attribute: .Bottom, relatedBy: .Equal, toItem: likeImgV, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
        contentView.layoutIfNeeded()
        let avaterImgWidth = avaterImgV.bounds.width
        avaterImgV.layer.cornerRadius = avaterImgWidth / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
