//
//  YRUserAlbumViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import CoreImage

class YRUserAlbumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "相册"
        let item: UIBarButtonItem = UIBarButtonItem(title: "选取", style: .Plain, target: self, action: #selector(selectedBtnClicked))
        navigationItem.rightBarButtonItem = item
        setUpViews()
    }
    
    private func setUpViews() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        view.addSubview(collectionView)
        
        let itemWidth = (UIScreen.mainScreen().bounds.width - 40) / 3
        layout.itemSize = CGSizeMake(itemWidth, itemWidth)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
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
        collectionView.registerClass(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        collectionView.contentInset = UIEdgeInsetsMake(12.0, 15.0, 0, 15.0)
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    
    func selectedBtnClicked() {
        print(#function)
    }
    
    // too slow and too much memory cost
    private func photo(imageName name: String) -> UIImage {
        let inputImg = UIImage(named: name)
        let beginImage = CIImage(image: inputImg!)
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter!.setValue(beginImage, forKey: "inputImage")
        let resultImage = blurFilter!.valueForKey("outputImage") as! CIImage
        let context = CIContext()
        let cgImageRef: CGImageRef = context.createCGImage(resultImage, fromRect: (beginImage?.extent)!)
        let blurredImage = UIImage(CGImage: cgImageRef, scale: (inputImg?.scale)!, orientation: .Up)
        return blurredImage
    }
}

extension YRUserAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        YRService.updateAvatarImage(data: imageData, success: { resule in
            dispatch_async(dispatch_get_main_queue()) {

            
            }
        }) { error in
            print("\(#function) error: \(error)")
        }
    }
}


extension YRUserAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            let limitedPickNum: Int = 4;
            YRPhotoPicker.photoMultiPickerFromAlert(inViewController: self, limited: limitedPickNum) {[weak self] photoAssets
                in
                print("        >>> finally - \(photoAssets.count) ")
                
            }
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = cell as! AlbumCell
        if indexPath.item == 0 {
            cell.photo.image = UIImage(named: "Proflie_AddPhoto")
            cell.selectedImgV.hidden = true
            cell.label.hidden = true
        }
        
        if indexPath.item == 1 {
            cell.label.text = "首张展示照片"
        }
    }
}

private class AlbumCell: YRPhotoPickViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.hexStringColor(hex: YRConfig.themeTintColor, alpha: 0.5)
        return label
    }()

//    let firstShowlabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
//        label.text = "首张展示照片"
//        label.textAlignment = .Center
//        label.textColor = UIColor.whiteColor()
//        return label
//    }()

    override func setUpViews() {
        super.setUpViews()
        layoutIfNeeded()
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = 5.0

        // debuge
        let img = UIImage(named: "demoAlbum.png")
        photo.image = img!.applyBlurWithRadius(5, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
        
        label.text = "未通过"
        photo.addSubview(label)
        let viewsDict = ["label" : label]
        let vflDict = ["H:|-0-[label]-0-|",
                       "V:[label]-0-|"]
        photo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        photo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        
        selectedImgV.hidden = false
        bringSubviewToFront(selectedImgV)
    }
}
