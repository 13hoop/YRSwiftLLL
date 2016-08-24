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

    var album: Album? {
        didSet {
            list = album?.list
        }
    }
    
    var list:[AlbumInfo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var item: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "相册"
        item = UIBarButtonItem(title: "编辑", style: .Plain, target: self, action: #selector(selectedBtnClicked))
        navigationItem.rightBarButtonItem = item
        setUpViews()
        loadData()
    }
    
    private func loadData() {
        YRService.requiredAlbumPhotos(page: 1, success: {[weak self] result in
            if let data = result!["data"] as? [String: AnyObject] {
                self?.album = Album(fromJSONDictionary: data)
            }
            }, fail: { error in
                print(error)
            })
    }
    
    private func setUpViews() {
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: .ValueChanged)
        collectionView.addSubview(refresh)
        
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
        collectionView.alwaysBounceVertical = true
        collectionView.registerClass(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        collectionView.contentInset = UIEdgeInsetsMake(12.0, 15.0, 0, 15.0)
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()

    
    //MARK: Action
    func selectedBtnClicked() {
        print(#function)
        item?.title = "删除"
    }
    
    func refreshData(sender: UIRefreshControl) {
        print(#function)
        sender.endRefreshing()
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
                // take photo here
            }
        
        }) { error in
            print("\(#function) error: \(error)")
        }
    }
}


extension YRUserAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
//    scroll
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let limitedPickNum: Int = 4;
            YRPhotoPicker.photoMultiPickerFromAlert(inViewController: self, limited: limitedPickNum) { photoAssets
                in
                print("        >>> finally - \(photoAssets.count) ")
            }
        }else {
            let vc = YRAlbumLargePhotoViewController()
            vc.list = self.list
            vc.showIndexPath = NSIndexPath(forItem: indexPath.item - 1, inSection: 0)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemsNum = ((self.list?.isEmpty) != nil) ? ((self.album?.list.count)! + 1 ) : 1
        return itemsNum
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
        }else {
            if let model: AlbumInfo = (self.album?.list[indexPath.row - 1]) {
                let url: NSURL = NSURL(string: model.url!)!
                if indexPath.item == 1 {
                    cell.label.text = "首张展示照片"
                    cell.label.hidden = false
                }else {
                }
                
                cell.photo.kf_setImageWithURL(url)
            }
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
        
//        selectedImgV.hidden = false
//        bringSubviewToFront(selectedImgV)
    }
}
