//
//  YRAuthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/11.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAuthViewController: UIViewController {

    @IBOutlet weak var avateImage: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    let insigniaView: YRInsigniaView = {
        let view = YRInsigniaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isAuthed: [Bool] = [true, false, false, false, false]
    private let authIconImagelist: [[String: String]] = [
        ["normal" : "my_actual_name_unactive", "selected" : "my_actual_name", "title": "实名"],
        ["normal" : "my_houses_unactive",      "selected" : "my_house",       "title": "房产"],
        ["normal" : "my_photos_unactive",      "selected" : "my_photos",      "title": "照片"],
        ["normal" : "my_photos_unactive",      "selected" : "my_photos",      "title": "车辆"],
        ["normal" : "my_photos_unactive",      "selected" : "my_photos",      "title": "学历"]
    ]
    private let contentTitle = ["0": "未认证", "2": "审核中", "1": "已认证"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        if let url = NSURL(string: YRUserDefaults.userAvatarURLStr) as NSURL? {
            UIImage.loadImageUsingKingfisher(url, completion: {[weak self] (image, error, cacheType, imageURL) in
                if let img = image {
                    self?.avateImage.image = img
                }
            })
        }
    }
    
    private func setUpViews() {
        insigniaView.collectionView.dataSource = self
        insigniaView.collectionView.delegate = self
        let layout = insigniaView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(YRSize.width, YRSize.height - 10)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0

        view.addSubview(insigniaView)
        let viewsDict = ["tipLabel" : tipLabel,
                         "insigniaView" : insigniaView]
        let vflDict = ["H:|-0-[insigniaView]-0-|",
                       "V:[tipLabel]-[insigniaView(height)]"]
        
        let metrics = ["height" : "\(YRSize.height)"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: metrics, views: viewsDict))
    }
}

extension YRAuthViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.item {
        case 0:
            let vc = UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YRRealNameAuthViewController") as! YRRealNameAuthViewController
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YRHouseAuthViewController") as! YRHouseAuthViewController
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YRPhotoAuthViewController") as! YRPhotoAuthViewController
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YRCatAuthViewController") as! YRCatAuthViewController
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = UIStoryboard(name: "Auths", bundle: nil).instantiateViewControllerWithIdentifier("YREducationViewController") as! YREducationViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YRInsigiaViewType.authCell.rawValue, forIndexPath: indexPath) as! AuthCell
        let contentData = self.authIconImagelist[indexPath.item]
        let isAuthed = self.isAuthed[indexPath.item]
        let showPic = isAuthed ? contentData["selected"] : contentData["normal"]
        
        cell.imgV.image = UIImage(named: showPic!)
        cell.titleLb.text = contentData["title"]
        return cell
    }
}

private struct YRSize {
    static let width: CGFloat = UIScreen.mainScreen().bounds.width / 5
    static let height: CGFloat = 120 // 与AuthTableViewCell等高
}
