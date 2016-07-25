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
        ["normal" : "my_houses_unactive", "selected" : "my_house", "title": "房产"],
        ["normal" : "my_photos_unactive", "selected" : "my_photos", "title": "照片"],
        ["normal" : "my_photos_unactive", "selected" : "my_photos", "title": "照片"],
        ["normal" : "my_photos_unactive", "selected" : "my_photos", "title": "照片"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        if let url = NSURL(string: YRUserDefaults.userAvatarURLStr) as NSURL? {
            avateImage.kf_setImageWithURL(url)
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
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("YRAuthActionViewController") as! YRAuthActionViewController
        navigationController?.pushViewController(vc, animated: true)
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
