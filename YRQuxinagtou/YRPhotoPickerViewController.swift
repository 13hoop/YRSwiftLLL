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

//private typealias yr_mutiPickerCallBack = 

class YRPhotoPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var maxSelectedNum: Int = 0
    private var photoAllArray = PHFetchResult()
    
    
    private var photoAssetsSet = Set<PHAsset>()
    
    private var photoLimited: Int = 0
    
    
    internal var completion: ((imageAssets: Set<PHAsset>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择照片" + "  \(photoLimited)\\\(maxSelectedNum)"
        setUpViews()
        
        fetchAllPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cellSize = collectionView.flowLayout.itemSize
        YR_AssetGridThumbnailSize.assetGridThumbnailSize = CGSizeMake(cellSize.width, cellSize.height)
    }
    
    private func setUpViews() {
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem:.Done, target: self, action: #selector(doneBtnClicked))
        navigationItem.rightBarButtonItem = doneBtn
        
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

        print("-- 取回\(photoAssetsSet.count)张，回传AssetSet --")
        completion?(imageAssets: photoAssetsSet)
        navigationController?.popViewControllerAnimated(true)
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
    
    let collectionView: YRPhotoCollectionView = {
        
        $0.backgroundColor = .whiteColor()
        $0.registerClass(YRPhotoPickViewCell.self, forCellWithReuseIdentifier: YR_ReusedIdentifer.cellIdentifer)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(YRPhotoCollectionView())
}

// MARK: YRPhotoPickViewCell
class YRPhotoPickViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        contentView.addSubview(photo)
        photo.addSubview(selectedImgV)
        
        let viewsDict = ["photo" : self.photo,
                         "selectedImgV": self.selectedImgV]
        let vflDict = ["H:|-0-[photo]-0-|",
                       "V:|-0-[photo]-0-|",
                       "H:[selectedImgV(20)]-0-|",
                       "V:|-0-[selectedImgV(20)]"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        photo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        photo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
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
}

// MARK: YRPhotoCollectionView
class YRPhotoCollectionView: UICollectionView {
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let flowLayout: YRFlowLayout = {
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
        //        headerReferenceSize = CGSizeMake(120.0, 30.0)
        scrollDirection = .Vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

