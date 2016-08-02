//
//  YRAlbumLargePhotoViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/27.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAlbumLargePhotoViewController: UIViewController {

    var showIndexPath: NSIndexPath?
    var list:[AlbumInfo]? {
        didSet {
            photoUrls = list?.map({ albumInfo -> NSURL in
                return NSURL(string: albumInfo.url!)!
            })
        }
    }
    var photoUrls: [NSURL]? {
        didSet {
            collectionView.reloadData()
            pageBar.numberOfPages = (photoUrls?.count)!
        }
    }
    
    var backBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("返回", forState: .Normal)
        view.setTitle("返回", forState: .Highlighted)
        view.backgroundColor = .clearColor()
        view.setTitleColor(.whiteColor(), forState: .Normal)
        view.titleLabel?.textAlignment = .Right
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(LargePhotoCell.self, forCellWithReuseIdentifier: "LargePhotoCell")
        collectionView.bounces = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.pagingEnabled = true
        return collectionView
    }()
    private let pageBar: UIPageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard photoUrls?.count != 0 else {
            return
        }
        collectionView.selectItemAtIndexPath(showIndexPath!, animated: false, scrollPosition: .CenteredHorizontally)
    }

    private func setUpViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        view.addSubview(collectionView)
        view.addSubview(pageBar)
        
        backBtn.addTarget(self, action: #selector(backBtnClicked), forControlEvents: .TouchUpInside)
        view.addSubview(backBtn)
        
        
        let viewsDict = ["collectionView" : collectionView,
                         "pageBar": pageBar,
                         "backBtn": backBtn]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|",
                       "H:|-0-[pageBar]-0-|",
                       "V:[pageBar(20)]-100-|",
                        "H:[backBtn(60)]-|",
                        "V:|-30-[backBtn(40)]"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
        
        view.layoutIfNeeded()
        layout.itemSize = CGSizeMake(collectionView.bounds.width, collectionView.bounds.height)
    }
    
    // Action
    func backBtnClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension YRAlbumLargePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoUrls!.count
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! LargePhotoCell
        let url: NSURL = self.photoUrls![indexPath.row]
        cell.imgV.kf_setImageWithURL(url)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LargePhotoCell", forIndexPath: indexPath) as! LargePhotoCell
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let xPos = scrollView.contentOffset.x + 10
        self.pageBar.currentPage = (Int)(xPos / width)
    }
}

private class LargePhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imgV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setUpViews() {
        backgroundColor = .blackColor()
        contentView.addSubview(imgV)
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV]-0-|",
                       "V:|-0-[imgV]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

