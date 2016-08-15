//
//  YRPhotoPickerAlertLikeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/11.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Photos

private struct YR_ReusedIdentifer {
    static let headerIdentifer: String = "yr_header"
    static let cellIdentifer: String = "yr_cell"
}

class YRPhotoPickerAlertLikeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var maxSelectedNum: Int = 0
    
    private var photoAllArray = PHFetchResult()
    private var photoAssetsSet = Set<PHAsset>()
    private var photoLimited: Int = 0
    
    let imageManager = PHCachingImageManager()    
    let dismissBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .whiteColor()
        view.setTitle("取 消", forState: .Normal)
        view.setTitle("取 消", forState: .Highlighted)
        view.setTitleColor(.redColor(), forState: .Normal)
        view.setTitleColor(.redColor(), forState: .Highlighted)
        return view
    }()
    
    let sendBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .whiteColor()
        view.setTitle("发 送", forState: .Normal)
        view.setTitle("发 送", forState: .Highlighted)
        view.setTitleColor(YRConfig.systemTintColored, forState: .Normal)
        view.setTitleColor(YRConfig.systemTintColored, forState: .Highlighted)
        return view
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .whiteColor()
        view.registerClass(YRPhotoPickViewCell.self, forCellWithReuseIdentifier: YR_ReusedIdentifer.cellIdentifer)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    internal var completion: ((imageAssets: Set<PHAsset>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let doneBtn = UIBarButtonItem(barButtonSystemItem:.Done, target: self, action: #selector(doneBtnClicked))
        navigationItem.rightBarButtonItem = doneBtn

        setUpViews()
        fetchAllPhotos()

        print("presented VC: \(self)")
    }
    
    private func setUpViews() {
        view.backgroundColor = UIColor.clearColor()
    
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.0
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 2.0
        layout.itemSize = CGSizeMake(150, 200)
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        sendBtn.addTarget(self, action: #selector(sendBtnClicked), forControlEvents: .TouchUpInside)
        view.addSubview(sendBtn)
    
        dismissBtn.addTarget(self, action: #selector(dismissBtnClicked), forControlEvents: .TouchUpInside)
        view.addSubview(dismissBtn)
        
        let viewsDict = ["collectionView" : collectionView,
                         "dismissBtn" : dismissBtn,
                         "sendBtn" : sendBtn]
        let vflDict = ["H:|[collectionView]|",
                       "H:|[dismissBtn]|",
                       "H:|[sendBtn]|",
                       "V:|-[collectionView(220)]-0-[sendBtn]-[dismissBtn]"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private func fetchAllPhotos() {
        photoAllArray = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        print(photoAllArray)
    }
    
    // MARK: -- Action --
    func doneBtnClicked() {
        print(" 2 --- done btn clicked and call completion{} here ---")
        completion?(imageAssets: photoAssetsSet)
    }
    
    func dismissBtnClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendBtnClicked() {
        
    }
    
    // MARK: -- DataSource and Delegate--
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAllArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YR_ReusedIdentifer.cellIdentifer, forIndexPath: indexPath) as! YRPhotoPickViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? YRPhotoPickViewCell {
            cell.imageManager = imageManager
            if let imageAsset = photoAllArray[indexPath.item] as? PHAsset {
                cell.imageAsset = imageAsset
                cell.selectedImgV.hidden = !photoAssetsSet.contains(imageAsset)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let asset = photoAllArray[indexPath.row] as! PHAsset
        if photoAssetsSet.contains(asset) {
            photoAssetsSet.remove(asset)
        }else {
            if photoAssetsSet.count + photoLimited == maxSelectedNum {
                return
            }else {
                photoAssetsSet.insert(asset)
            }
        }
        title = "发送照片(" + "\(photoAssetsSet.count + photoLimited)\\\(maxSelectedNum)" + ")"
        sendBtn.setTitle(title, forState: .Normal)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! YRPhotoPickViewCell
        cell.selectedImgV.hidden = !cell.selectedImgV.hidden
    }

}

//
extension YRPhotoPickerAlertLikeViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YRBouncyAnimator()
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {

        print(#function)

        return YROverlyPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

