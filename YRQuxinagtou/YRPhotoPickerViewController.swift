//
//  YRPhotoPickerViewController.swift
//  YRPhotoPicker
//
//  Created by YongRen on 16/5/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Photos

public enum YRPickerType {
    case Album
    case Normal
}

private struct YR_ReusedIdentifer {
    static let headerIdentifer: String = "yr_header"
    static let cellIdentifer: String = "yr_cell"
}

struct YR_AssetGridThumbnailSize {
    static var assetGridThumbnailSize = CGSizeZero
}

class YRPhotoPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var maxSelectedNum: Int = 0
    private var photoAllArray = PHFetchResult()
    
    let imageManager = PHCachingImageManager()
    private var photoAssetsSet = Set<PHAsset>()
    private var photoLimited: Int = 0
    
    internal var completion: ((imageAssets: Set<PHAsset>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择照片" + "  \(photoLimited)\\\(maxSelectedNum)"
        let doneBtn = UIBarButtonItem(barButtonSystemItem:.Done, target: self, action: #selector(doneBtnClicked))
        navigationItem.rightBarButtonItem = doneBtn
        setUpViews()
        fetchAllPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cellSize = collectionView.flowLayout.itemSize
        YR_AssetGridThumbnailSize.assetGridThumbnailSize = CGSizeMake(cellSize.width, cellSize.height)
    }
    
    private func setUpViews() {

        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|[collectionView]|",
                       "V:|-0-[collectionView]-0-|"]
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
        navigationController?.popViewControllerAnimated(true)
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
        title = "选择照片" + "  \(photoAssetsSet.count + photoLimited)\\\(maxSelectedNum)"
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! YRPhotoPickViewCell
        cell.selectedImgV.hidden = !cell.selectedImgV.hidden
    }
    
    let collectionView: YRPhotoCollectionView = {
        $0.backgroundColor = .whiteColor()
        $0.registerClass(YRPhotoPickViewCell.self, forCellWithReuseIdentifier: YR_ReusedIdentifer.cellIdentifer)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(YRPhotoCollectionView())
}



