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
            print(" next page : \(album?.next_page)")
            list += (album?.list)!
        }
    }
    
    var isSpical: Bool = false
    private var list:[AlbumInfo] = [] {
        didSet {
            
            print("   had  appeneded  list  here  \(list.count) ")
            collectionView.reloadData()
        }
    }
    private var item: UIBarButtonItem?
    private var heightConstraint: NSLayoutConstraint?
    private let refreshView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let refreshLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "加载中..."
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        return label
    }()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.registerClass(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
        collectionView.contentInset = UIEdgeInsetsMake(12.0, 15.0, 0, 15.0)
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "相册"
        item = UIBarButtonItem(title: "编辑", style: .Plain, target: self, action: #selector(selectedBtnClicked))
        navigationItem.rightBarButtonItem = item
        setUpViews()
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        if isSpical {
            let firstIndexPath = NSIndexPath(forItem: 0, inSection: 1)
            self.collectionView(collectionView, didSelectItemAtIndexPath: firstIndexPath)
        }
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
        refresh.addTarget(self, action: #selector(refreshAction(_:)), forControlEvents: .ValueChanged)
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
        
        refreshView.addSubview(refreshLabel)
        refreshView.backgroundColor = YRConfig.themeTintColored
        view.addSubview(refreshView)
        
        let viewsDict = ["collectionView" : collectionView,
                         "refreshView": refreshView,
                         "label" : refreshLabel]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-[refreshView]-0-|",
                       "H:|-0-[refreshView]-0-|",
                       "H:|[label]|",
                       "V:|[label]|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        refreshView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        refreshView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        heightConstraint = NSLayoutConstraint(item: refreshView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0)
        view.addConstraint(heightConstraint!)
    }
    
    //MARK: Action
    func selectedBtnClicked() {
        print(#function)
        item?.title = "删除"
    }
    
    func refreshAction(sender: UIRefreshControl) {
        self.refreshData()
        sender.endRefreshing()
    }
    
    private func refreshData() {
        guard self.album!.hasNextPage else { return }        
        print(album?.next_page!)
        YRService.requiredAlbumPhotos(page: (album?.next_page)!, success: {[weak self] result in
            if let data = result!["data"] as? [String: AnyObject] {
                self?.album = Album(fromJSONDictionary: data)
            }
        }, fail: { error in
            print(error)
        })
    }
}

extension YRUserAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        print("        📸📸📸📸    ")
        
//        YRService.updateAvatarImage(data: imageData, success: { resule in
//
//            dispatch_async(dispatch_get_main_queue()) {
//                // take photo here
//
//            }
//        }) { error in
//            print("\(#function) error: \(error)")
//        }
    }
}


extension YRUserAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            
            let limitedPickNum: Int = 4;
            YRPhotoPicker.photoMultiPickerFromAlert(inViewController: self, limited: limitedPickNum) { images
                in
                print("        >>> finally - \(images) ")
                var updateDatas: [NSData] = []
                for img in images {
                    let data = UIImagePNGRepresentation(img)!
                    updateDatas.append(data)
                }

                guard !updateDatas.isEmpty else {  return  }
                YRService.upLoadGalleryImage(datas: updateDatas, success: { (result) in
                    print(result)
                
                    
                }, fail: { error in
                    print(" upLoad gallery images error:\(error) ")
                })
            }
            
        }else {
            let vc = YRAlbumLargePhotoViewController()
            vc.list = self.list
            vc.showIndexPath = NSIndexPath(forItem: indexPath.item - 1, inSection: 0)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemsNum = self.list.isEmpty ? 1 : self.list.count + 1
        
        return itemsNum
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! AlbumCell
        switch indexPath.item {
        case 0:
            cell.photo.image = UIImage(named: "Proflie_AddPhoto")
            cell.selectedImgV.hidden = true
            cell.label.hidden = true
        case 1:
            let model: AlbumInfo = list[0]
            let url: NSURL = NSURL(string: model.url!)!
            cell.photo.kf_setImageWithURL(url)
            cell.label.text = "首张展示照片"
            cell.label.hidden = false
        default:
            let model: AlbumInfo = list[indexPath.item - 1]
            let url: NSURL = NSURL(string: model.url!)!
            cell.photo.kf_setImageWithURL(url)
            cell.label.text = "\(indexPath.item - 1)"
            cell.label.hidden = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! AlbumCell
        cell.photo.image = nil
        cell.selectedImgV.hidden = true
        cell.label.hidden = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.refreshLabel.text = self.album!.hasNextPage ? "正在拼命加载中..." : "没有更多了"
        self.refreshLabel.textColor = self.album!.hasNextPage ? .whiteColor() : .redColor()

        let defultInsert = collectionView.contentInset
        if scrollView.contentOffset.y + scrollView.frame.size.height  >= scrollView.contentSize.height + 50 {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations:{ [weak self] in
                self?.heightConstraint?.constant = 80
                self?.view.layoutIfNeeded()
                self?.collectionView.contentInset = UIEdgeInsetsMake(12, 15, 80, 15)
                }, completion: {[weak self] (finished) in
                    self?.refreshData()
                    self?.collectionView.contentInset = defultInsert
                    self?.heightConstraint?.constant = 0
                    self?.view.layoutIfNeeded()
                })
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
//        let img = UIImage(named: "demoAlbum.png")
//        photo.image = img!.applyBlurWithRadius(5, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
        
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
