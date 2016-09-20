//
//  YRVisitorViewController.swift
//  YRQuxinagtou
//
//  Created by Meng Ye on 16/9/12.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRVisitorViewController: UIViewController {
    var visitors: Visitors? {
        didSet {
            list += (visitors?.list)!
        }
    }
    
    private var list: [VisitorOne] = [] {
        didSet {
            print(list.count)
            collectionView.reloadData()
        }
    }
    
    private var heightFreshViewConstraint: NSLayoutConstraint?

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
        setUpViews()
    }
    
    private func loadData() {
        YRService.requiredVisitor(page: 1, success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                let visitorsModel = Visitors(fromJSONDictionary: data)
                self.visitors = visitorsModel
            }
        }, fail: { error in
            print(" visitors error: \(error)")
        })
    }
    
    //MARK: Action
    private func refreshData() {
        guard self.visitors!.hasNextPage else { return }
        print(visitors?.next_page!)
        
        YRService.requiredVisitor(page: (visitors?.next_page)!, success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                let visitorsModel = Visitors(fromJSONDictionary: data)
                self.visitors = visitorsModel
            }
            }, fail: { error in
                print(" refresh visitors error: \(error)")
        })

    }
    
    private func setUpViews() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        view.addSubview(collectionView)
        
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
                         "label" : refreshLabel]
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
        
        heightFreshViewConstraint = NSLayoutConstraint(item: refreshView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0)
        view.addConstraint(heightFreshViewConstraint!)
    }
}

extension YRVisitorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model: VisitorOne = self.list[indexPath.item]
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
        let model: VisitorOne = list[indexPath.item]
        let cell = cell as! YRSearchedFreandsCell
        cell.nameLb.text = model.nickname
        cell.statusImgV.backgroundColor = model.isOnline ? UIColor.greenColor() : UIColor.yellowColor()
        let url = NSURL(string: model.avatar!)
        cell.avaterImgV.kf_showIndicatorWhenLoading = true
        cell.avaterImgV.kf_setImageWithURL(url!)
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! YRSearchedFreandsCell
        cell.avaterImgV.image = nil
        cell.nameLb.text = ""
        cell.statusImgV.backgroundColor = UIColor.yellowColor()
        cell.likeImgV.image = nil
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.refreshLabel.text = self.visitors!.hasNextPage ? "正在拼命加载中..." : "没有更多了"
        self.refreshLabel.textColor = self.visitors!.hasNextPage ? .whiteColor() : .redColor()
        
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
                self?.view.layoutIfNeeded()
                }, completion: { [weak self]  _ in
            })
        }else {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: { [weak self] in
                self?.view.layoutIfNeeded()
                }, completion: { [weak self] _ in
            })
        }
    }
}
