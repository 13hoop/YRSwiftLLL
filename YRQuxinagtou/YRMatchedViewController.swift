//
//  YRMatchedViewController.swift
//  YRQuxinagtou
//
//  Created by Meng Ye on 16/9/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRMatchedViewController: UIViewController {
    // 当前请求的，与我配对的人
    var matched: Matched? {
        didSet {
            matchedList += (matched?.list)!
        }
    }
    
    // 存放所有与我配对的人
    private var matchedList: [MatchedOne] = [] {
        didSet {
            print("debug" + String(matchedList.count))
            matchedCollectionView.reloadData()
        }
    }
    
    // 当前请求的，喜欢我的人
    var likedMe: LikedMe? {
        didSet {
            likedMeList += (likedMe?.list)!
        }
    }
    
    // 存放所有喜欢我的人
    private var likedMeList: [LikedMeOne] = [] {
        didSet {
            print("debug" + String(likedMeList.count))
            likedMeCollectionView.reloadData()
        }
    }
    
    // 已配对的
    private var matchedCollectionView: UICollectionView!
    // 喜欢我的
    private var likedMeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        loadData()
    }
    
    private func loadData() {
        YRService.requiredMatched(page: 1, success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                let matchedModel = Matched(fromJSONDictionary: data)
                self.matched = matchedModel
            }
            }, fail: { error in
                print(" visitors error: \(error)")
        })
        
        YRService.requiredLikedMe(page: 1, success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                let likedMeModel = LikedMe(fromJSONDictionary: data)
                self.likedMe = likedMeModel
            }
            }, fail: { error in
                print(" visitors error: \(error)")
        })
    }
    
    private func setUpViews() {
        matchedCollectionView = initCollectionView()
        setUpCollectionView(matchedCollectionView)
        
        likedMeCollectionView = initCollectionView()
        setUpCollectionView(likedMeCollectionView)
    }
    
    private func initCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsetsMake(30.0, 8.0, 0, 8.0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        
        return collectionView
    }
    
    private func setUpCollectionView(collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (UIScreen.mainScreen().bounds.width - 40) / 3
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 20)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        layout.scrollDirection = .Vertical
        
        view.addSubview(collectionView)
    }
}

extension YRMatchedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == matchedCollectionView {
            // 与我配对的
        } else {
            // 喜欢我的
        }
//        let model: VisitorOne = self.list[indexPath.item]
//        let uuid = model.uuid!
//        
//        let vc = YRFriendOneViewController()
//        vc.hidesBottomBarWhenPushed = true
//        vc.uuid = uuid
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == matchedCollectionView {
            return matchedList.count
        } else {
            return likedMeList.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PeopleItemCell", forIndexPath: indexPath) as! PeopleItemCollectionViewCell
        if collectionView == matchedCollectionView {
            cell.configureMatched(matchedList[indexPath.row])
        } else {
            cell.configureLikedMe(likedMeList[indexPath.row])
        }
        
        return cell
    }
}
