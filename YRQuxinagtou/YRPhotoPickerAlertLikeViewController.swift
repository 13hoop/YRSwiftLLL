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
        
        setUpViews()
        fetchAllPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let cellSize = collectionView.flowLayout.itemSize
//        YR_AssetGridThumbnailSize.assetGridThumbnailSize = CGSizeMake(cellSize.width, cellSize.height)
    }
    
    private func setUpViews() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem:.Done, target: self, action: #selector(doneBtnClicked))
        navigationItem.rightBarButtonItem = doneBtn
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 2.0
        layout.itemSize = CGSizeMake(100, 100)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|[collectionView]|",
                       "V:|-[collectionView(120)]"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
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
    
    // MARK: -- DataSource and Delegate--
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAllArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YR_ReusedIdentifer.cellIdentifer, forIndexPath: indexPath) as! YRPhotoPickViewCell
        
        let asset = photoAllArray[indexPath.row] as! PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: YR_AssetGridThumbnailSize.assetGridThumbnailSize, contentMode: PHImageContentMode.Default, options: nil) { (image, _) in
            cell.photo.image = image
        }
        
        return cell
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
        
        title = "选择照片" + "  \(photoAssetsSet.count + photoLimited)\\\(maxSelectedNum)"
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

class YRBouncyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let targetVC = transitionContext.viewForKey(UITransitionContextToViewKey) {
            
            let centre = targetVC.center
            
            targetVC.center = CGPointMake(centre.x, CGRectGetHeight(targetVC.bounds))
            
            transitionContext.containerView()?.addSubview(targetVC)
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [], animations: {
                targetVC.center = centre
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}

class YROverlyPresentationController: UIPresentationController {
    
    let dimmingView = UIView()
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
//        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
        
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        dimmingView.addGestureRecognizer(tap)
    }
    
    func tapAction() {
        print(#function)

    }
    
    override func presentationTransitionWillBegin() {
        print(#function)
    
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        
        print(" containerView: \(containerView)")
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
            context in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        print(#function)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
            context in
            self.dimmingView.alpha = 0.0
            }, completion: {
                context in
                self.dimmingView.removeFromSuperview()
        })
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let rect = presentedView()!.bounds
        let first = CGRectMake(0, 300, rect.width, CGRectGetHeight(rect) - 300)
        return first.insetBy(dx: 10, dy: 0)
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = (containerView?.bounds)!
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
}
