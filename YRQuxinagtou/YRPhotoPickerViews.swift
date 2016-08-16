//
//  YRPhotoPickerViews.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/15.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Photos

// MARK: YRPhotoPickViewCell
class YRPhotoPickViewCell: UICollectionViewCell {
    
    var imageManager = PHCachingImageManager()
    var imageAsset: PHAsset? {
        willSet {
            guard let imageAsset = newValue else {
                return
            }
            let options = PHImageRequestOptions()
            options.synchronous = true // 同步
            options.version = .Current
            options.deliveryMode = .HighQualityFormat
            options.resizeMode = .Exact
            options.networkAccessAllowed = true
            
            self.imageManager.requestImageForAsset(imageAsset, targetSize: CGSize(width: 120, height: 120), contentMode: .AspectFill, options: options) { [weak self] image, info in
                self?.photo.image = image
            }
        }
    }
    
    let photo: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    let selectedImgV: UIImageView = {
        $0.image = UIImage(named: "icon_imagepicker_check")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hidden = true
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        contentView.addSubview(photo)
        contentView.addSubview(selectedImgV)
        
        let viewsDict = ["photo" : self.photo,
                         "selectedImgV": self.selectedImgV]
        let vflDict = ["H:|-0-[photo]-0-|",
                       "V:|-0-[photo]-0-|",
                       "H:[selectedImgV(20)]-0-|",
                       "V:|-0-[selectedImgV(20)]"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: YRPhotoCollectionView
class YRPhotoCollectionView: UICollectionView {
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var flowLayout: YRFlowLayout = {
        return $0
    }(YRFlowLayout())
}

// MARK: YRFlowLayout
class YRFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        let width = UIScreen.mainScreen().bounds.width / 4.0 - 2
        itemSize = CGSizeMake(width, width)
        minimumInteritemSpacing = 2.0
        minimumLineSpacing = 2.0
        scrollDirection = .Vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: bouncy animator
class YRBouncyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let targetVC = transitionContext.viewForKey(UITransitionContextToViewKey) {
            
            let centre = targetVC.center
            
            targetVC.center = CGPointMake(centre.x, CGRectGetHeight(targetVC.bounds))
            
            transitionContext.containerView()?.addSubview(targetVC)
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                targetVC.center = centre
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}

// MARK: Custom Overly presentation cotroller
class YROverlyPresentationController: UIPresentationController {
    
    let dimmingView = UIView()
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        dimmingView.addGestureRecognizer(tap)
    }
    
    func tapAction() {
        self.presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView!.insertSubview(dimmingView, atIndex: 0)
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
            context in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
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
        let first = CGRectMake(0, 350, rect.width, CGRectGetHeight(rect) - 350)
        return first.insetBy(dx: 10, dy: 0)
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = (containerView?.bounds)!
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
}

