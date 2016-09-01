//
//  YRProfileTableViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Kingfisher

class YRProfileTableViewController: UITableViewController {

    var profile: Profile? {
        willSet {
            nickNameLb.text = newValue?.nickname
            remainMoney.text = newValue?.balance
            usedMoney.text = newValue?.consume
            
            let avatarUrl: NSURL = NSURL(string: (newValue?.avatar)!)!
            avatarBtn.kf_setBackgroundImageWithURL(avatarUrl, forState: .Normal)
            avatarBtn.kf_setBackgroundImageWithURL(avatarUrl, forState: .Highlighted)
            
            imageRecent = newValue?.recent_images
            
            // ToDo: is auth arr here
            print(newValue?.isAuthedArray)
            authList = (newValue?.isAuthedArray)!
            
            insigniaView?.insigniaView.collectionView.reloadData()
            authView?.insigniaView.collectionView.reloadData()
        }
    }
    
    var isAuthed: [Bool] = [false, false, false, false, false]
    var imageRecent: [NSURL]? = [] {
        didSet {
            print("   recent image url setter here   ")
//            print("   recent image url setter here:  \(imageRecent) ")
            if let urls = imageRecent {
                let count = urls.count
                guard count > 0 else { return }
                switch count - 1 {
                case 0:
                    recentImgVCollection[0].kf_setImageWithURL(urls[0])
                case 1:
                   recentImgVCollection[0].kf_setImageWithURL(urls[0])
                   recentImgVCollection[1].kf_setImageWithURL(urls[1])
                default:
                    recentImgVCollection[0].kf_setImageWithURL(urls[0])
                    recentImgVCollection[1].kf_setImageWithURL(urls[1])
                    recentImgVCollection[2].kf_setImageWithURL(urls[2])
                }
            
            }
        }
    }
    
    @IBOutlet var recentImgVCollection: [UIImageView]!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nickNameLb: UILabel!
    
    typealias mutiImagesPickerDone = (images: [UIImage]) -> Void
    var pickImageDone: mutiImagesPickerDone?
    
    @IBOutlet weak var remainMoney: UILabel!
    @IBOutlet weak var usedMoney: UILabel!
    var insigniaView: InsigniaTableViewCell?
    var authView: InsigniaTableViewCell?

    
    private var authList: [String?] = []
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

        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        tableView.backgroundView? = v
        
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView?.backgroundColor = .clearColor()
        tabBarController?.hidesBottomBarWhenPushed = true
        self.clearsSelectionOnViewWillAppear = false
    }
    
    private func loadProfileData() {
        YRService.requiredProfile(success: { result in
            if let data = result!["data"] as? [String: AnyObject] {
                let profile = Profile(fromJSONDictionary: data)
                self.profile = profile
            }
            
        }) { (error) in
            print("\(#function) error: \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         loadProfileData()
    }

    // MARK: -- Action --
    @IBAction func changeAvatarBtn(sender: AnyObject) {
        YRPhotoPicker.photoSinglePickerFromAlert(inViewController: self)
    }
    
    @IBAction func addPhotoBtn(sender: AnyObject) {
        let limitedPickNum: Int = 4;
        YRPhotoPicker.photoMultiPickerFromAlert(inViewController: self, limited: limitedPickNum) { photoAssets in
            print("        >>> finally - \(photoAssets.count) ")
        }
    }
    
    // MARK: ----- Table view data source -----
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 2 where indexPath.row == 1:
            let cell = InsigniaTableViewCell(style: .Default, reuseIdentifier: "insigniaViewCell")
            self.insigniaView = cell
            cell.insigniaView.collectionView.dataSource = self
            cell.insigniaView.collectionView.delegate = self
            // auth
            let layout = cell.insigniaView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSizeMake(YRSize.width, YRSize.authHeight - 15)
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            layout.scrollDirection = .Horizontal
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0

            return cell
        case 3 where indexPath.row == 1:
            let cell = InsigniaTableViewCell(style: .Default, reuseIdentifier: "insigniaViewCell")
            self.authView = cell
            cell.insigniaView.collectionView.dataSource = self
            cell.insigniaView.collectionView.delegate = self
            // insign
            let layout = cell.insigniaView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSizeMake(YRSize.width, YRSize.insigHeight - 18)
            layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0)
            layout.scrollDirection = .Horizontal
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0

            return cell
        default:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 2 where indexPath.row == 1:
            return 110
        case 3 where indexPath.row == 1:
            return 90
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = YRProfileInfoViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.tempProfile = self.profile
                navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = YRUserAlbumViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = YRPurchedViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = YROrderListViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        case 4:
            let vc = YRFastOpViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = YRAddressViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = YRBlackListViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            print(" -- To do here at \(indexPath.section) - \(indexPath.row) !")
        }
    }
}

// MARK: ---- UIImagePickerControllerDelegate ----
extension YRProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        YRService.updateAvatarImage(data: imageData, success: { resule in
                dispatch_async(dispatch_get_main_queue()) {
                    self.avatarBtn.setBackgroundImage(image, forState: .Normal)
                }
            }) { error in
                print("\(#function) error: \(error)")
            }
    }
}

// MARK:  -- UICollectionViewDataSource ...  --
extension YRProfileTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.insigniaView?.insigniaView.collectionView {
            return self.authList.count
        }else if collectionView == self.authView?.insigniaView.collectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.insigniaView?.insigniaView.collectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YRInsigiaViewType.authCell.rawValue, forIndexPath: indexPath) as! AuthCell
        
            let contentData = self.authIconImagelist[indexPath.item]
            
            // pic have two status, and text 3 status
            let status = authList[indexPath.item]!
            let showPic = status == "1" ? contentData["selected"] : contentData["normal"]
            cell.imgV.image = UIImage(named: showPic!)
            cell.titleLb.text = contentData["title"]
            let str = contentTitle[status]
            cell.btn.setTitle(str, forState: .Normal)
            return cell

        }else if collectionView == self.authView?.insigniaView.collectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YRInsigiaViewType.insigniaCell.rawValue, forIndexPath: indexPath) as! InsigniaCell
            return cell
        }

        return UICollectionViewCell()
    }
}

// Private Size Struct
private struct YRSize {
    static let width: CGFloat = UIScreen.mainScreen().bounds.width / 5
    static let authHeight: CGFloat = 110 // 与AuthTableViewCell等高
    static let insigHeight: CGFloat = 85 // 与InsigTableViewCell等高
}