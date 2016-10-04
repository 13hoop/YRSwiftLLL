//
//  YRSearchViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRSearchViewController: UIViewController {

    var friends: Friends? {
        didSet {
            list += (friends?.list)!
        }
    }
    
    private var list: [FriendOne] = [] {
        didSet {
//            print(list.count)
            collectionView.reloadData()
        }
    }
    
    private var heightFreshViewConstraint: NSLayoutConstraint?
    private var heightAdviewConstraint: NSLayoutConstraint?
    private let adView: AdView = {
        let view = AdView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsetsMake(30.0, 8.0, 0, 8.0)
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
    private let refreshLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "拼命加载中..."
        label.textColor = YRConfig.mainTextColored
        label.textAlignment = .Center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setNvgViews()
        setUpViews()
    }
    
    private func loadData() {
        YRService.requiredFriends(page: 1, success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                let friendsModel = Friends(fromJSONDictionary: data)
                self.friends = friendsModel
            }
        }, fail: { error in
            print(" search friends error: \(error)")
        })
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
        
        view.addSubview(adView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAdViewAction))
        adView.addGestureRecognizer(tap)
        
        refreshView.addSubview(refreshLabel)
        refreshView.backgroundColor = UIColor.redColor()
        view.addSubview(refreshView)
        
        let itemWidth = (UIScreen.mainScreen().bounds.width - 40) / 3
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 20)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        layout.scrollDirection = .Vertical
        
        let viewsDict = ["collectionView" : collectionView,
                         "refreshView": refreshView,
                         "label" : refreshLabel,
                         "adView" : adView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-[refreshView]-40-|",
                       "H:|-0-[refreshView]-0-|",
                       "H:|[label]|",
                       "V:|[label]|",
                       "H:|[adView]|",
                       "V:|-64-[adView]"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        refreshView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        refreshView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[6] as String, options: [], metrics: nil, views: viewsDict))
        
        heightFreshViewConstraint = NSLayoutConstraint(item: refreshView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0)
        view.addConstraint(heightFreshViewConstraint!)
        heightAdviewConstraint =  NSLayoutConstraint(item: adView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 30)
        view.addConstraint(heightAdviewConstraint!)
    }
    
    //MARK: Action
    private func refreshData() {
        guard self.friends!.hasNextPage else { return }
        print(friends?.next_page!)
        
        YRService.requiredFriends(page: (friends?.next_page)!, success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                let friendsModel = Friends(fromJSONDictionary: data)
                self.friends = friendsModel
            }
            }, fail: { error in
                print(" refresh friends error: \(error)")
        })

    }
    
    func fileUsersAction() {
        let vc = YRSearchFilterViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func greaterAction() {
        print(#function)
    }
    
    func tapAdViewAction() {
        let vc = YRAdvertiseViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension YRSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model: FriendOne = self.list[indexPath.item]
        let uuid = model.uuid!
        
        let vc = YRFriendOneViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.uuid = uuid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRSearchedFreandsCell", forIndexPath: indexPath) as! YRSearchedFreandsCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let model: FriendOne = list[indexPath.item]
        let cell = cell as! YRSearchedFreandsCell
        cell.nameLb.text = model.nickname
        cell.onlinImgV.backgroundColor = model.isOnline ? UIColor.greenColor() : UIColor.yellowColor()
        let url = NSURL(string: model.avatar!)
        cell.avaterImgV.kf_showIndicatorWhenLoading = true
        cell.avaterImgV.kf_setImageWithURL(url!)
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! YRSearchedFreandsCell
        cell.avaterImgV.image = nil
        cell.nameLb.text = ""
        cell.onlinImgV.backgroundColor = UIColor.yellowColor()
        cell.certificatedImgV.image = nil
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.refreshLabel.text = self.friends!.hasNextPage ? "正在拼命加载中..." : "没有更多了"
        self.refreshLabel.textColor = self.friends!.hasNextPage ? .whiteColor() : .redColor()
        
        let defultInsert = collectionView.contentInset
        if scrollView.contentOffset.y + scrollView.frame.size.height  >= scrollView.contentSize.height + 50 {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations:{ [weak self] in
                
                self?.heightFreshViewConstraint?.constant = 80
                self?.view.layoutIfNeeded()
                self?.collectionView.contentInset = UIEdgeInsetsMake(72, 8, 80, 8)
                }, completion: {[weak self] (finished) in
                    self?.refreshData()
                    self?.collectionView.contentInset = defultInsert
                    self?.heightFreshViewConstraint?.constant = 0
                    self?.view.layoutIfNeeded()
                })
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: { [weak self] in
                self?.heightAdviewConstraint?.constant = 0
                self?.view.layoutIfNeeded()
                }, completion: { [weak self]  _ in
                self?.adView.hidden = true
            })
        }else {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: { [weak self] in
                self?.heightAdviewConstraint?.constant = 30
                self?.view.layoutIfNeeded()
                }, completion: { [weak self] _ in
                self?.adView.hidden = false
            })
        }
    }
}

