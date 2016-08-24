//
//  YRSearchViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRSearchViewController: UIViewController {

    var data:[String] = ["", "", "", "", ""]
    var heightConstraint: NSLayoutConstraint?
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsetsMake(8.0, 8.0, 0, 8.0)
        collectionView.alwaysBounceVertical = true
        collectionView.registerClass(YRSearchedFreandsCell.self, forCellWithReuseIdentifier: "YRSearchedFreandsCell")
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    
    private let refreshView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNvgViews()
        setUpViews()
    }
    
    private func setNvgViews() {
        let fileIterm = UIBarButtonItem(title: "筛选", style: .Plain, target: self, action: #selector(fileUsersAction))
        let greaterItem = UIBarButtonItem(title: "打招呼", style: .Plain, target: self, action: #selector(greaterAction))
        navigationItem.leftBarButtonItem = fileIterm
        navigationItem.rightBarButtonItem = greaterItem
    }
    
    private func setUpViews() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        view.addSubview(collectionView)
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "拼命加载中..."
        label.textColor = YRConfig.mainTextColored
        label.textAlignment = .Center
        refreshView.addSubview(label)
        refreshView.backgroundColor = UIColor.redColor()
        view.addSubview(refreshView)
        
        let itemWidth = (UIScreen.mainScreen().bounds.width - 40) / 3
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 20)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        layout.scrollDirection = .Vertical
        
        
        let viewsDict = ["collectionView" : collectionView,
                         "refreshView": refreshView,
                         "label" : label]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-[refreshView]-40-|",
                       "H:|-0-[refreshView]-0-|",
                       "H:|[label]|",
                       "V:|[label]|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        refreshView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        refreshView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        
        heightConstraint = NSLayoutConstraint(item: refreshView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0)
        view.addConstraint(heightConstraint!)
    }
    
    //MARK: Action
    func fileUsersAction() {
        let vc = YRSearchFilterViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func greaterAction() {
        print(#function)
    }
}

extension YRSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRSearchedFreandsCell", forIndexPath: indexPath) as! YRSearchedFreandsCell
        return cell
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let defultInsert = collectionView.contentInset
        print(defultInsert)
        
        
        if scrollView.contentOffset.y + scrollView.frame.size.height  >= scrollView.contentSize.height + 50 {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations:{ [weak self] in
                
                self?.heightConstraint?.constant = 80
                self?.view.layoutIfNeeded()
                self?.collectionView.contentInset = UIEdgeInsetsMake(72, 8, 80, 8)
                }, completion: {[weak self] (finished) in
                    print(finished)
                    for _ in 0 ..< 10 {
                        self?.data.append(" ")
                    }
                    self?.collectionView.reloadData()
                    self?.collectionView.contentInset = defultInsert
                    self?.heightConstraint?.constant = 0
                    self?.view.layoutIfNeeded()
                })
        }
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
