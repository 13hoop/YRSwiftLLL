//
//  YRProfileTableViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileTableViewController: UITableViewController {

    var profile: Profile? {
        willSet {
            nickNameLb.text = newValue?.nickname
            remainMoney.text = newValue?.balance
            usedMoney.text = newValue?.consume
            
            // ToDo: is auth arr here
            insigniaView?.insigniaView.collectionView.reloadData()
            authView?.insigniaView.collectionView.reloadData()
            }
    }
    
    var isAuthed: [Bool] = [true, false, false, false, false]
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nickNameLb: UILabel!
    
    @IBOutlet var photosImgVs: [UIImageView]!
    
    @IBOutlet weak var remainMoney: UILabel!
    @IBOutlet weak var usedMoney: UILabel!
    var insigniaView: YRInsigniaViewCell?
    var authView: YRInsigniaViewCell?
    
    private let authIconImagelist: [[String: String]] = [
        ["normal" : "my_actual_name_unactive", "selected" : "my_actual_name", "title": "实名"],
        ["normal" : "my_houses_unactive", "selected" : "my_house", "title": "房产"],
        ["normal" : "my_photos_unactive", "selected" : "my_photos", "title": "照片"]
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        tableView.backgroundView? = v
        
        tableView.tableFooterView = UIView()
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
        YRPhotoPicker.photoMultiPickerFromAlert(inViewController: self, limited: limitedPickNum)
    }
    internal func updatePhoto() {

    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 2 where indexPath.row == 1:
            print("  验证  ")
            let cell = YRInsigniaViewCell(style: .Default, reuseIdentifier: "insigniaViewCell")
            self.insigniaView = cell
            cell.insigniaView.collectionView.dataSource = self
            cell.insigniaView.collectionView.delegate = self
            
            let layout = cell.insigniaView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSizeMake(YRSize.width, YRSize.authHeight - 15)
            layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0)
            layout.scrollDirection = .Horizontal
            layout.minimumLineSpacing = 10.0
            layout.minimumInteritemSpacing = 0.0

            return cell
        case 3 where indexPath.row == 1:
            print("  勋章  ")
            let cell = YRInsigniaViewCell(style: .Default, reuseIdentifier: "insigniaViewCell")
            self.authView = cell
            cell.insigniaView.collectionView.dataSource = self
            cell.insigniaView.collectionView.delegate = self
            
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
                parentViewController!.hidesBottomBarWhenPushed = true
                let vc = YRProfileInfoViewController()
                vc.profile = self.profile
                navigationController?.pushViewController(vc, animated: true)
                parentViewController!.hidesBottomBarWhenPushed = false
            default:
                parentViewController!.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(YRUserAlbumViewController(), animated: true)
                parentViewController!.hidesBottomBarWhenPushed = false
            }
        case 2:
            print(" go to AuthVC")
        case 4:
            navigationController?.pushViewController(YRFastOpViewController(), animated: true)
        case 5:
            print(" go to Address")
        case 6:
            navigationController?.pushViewController(YRBlackListViewController(), animated: true)
        default:
            print(" -- To do here at \(indexPath.section) - \(indexPath.row) !")
        }
    }
}

extension YRProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.updatePhoto()
        dispatch_async(dispatch_get_main_queue()) {
            self.avatarBtn.setBackgroundImage(image, forState: .Normal)
        }
    }
}

class YRInsigniaViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews() {

        contentView.addSubview(insigniaView)

        let viewsDict = ["insigniaView" : insigniaView]
        let vflDict = ["H:|-0-[insigniaView]-0-|",
                       "V:|-0-[insigniaView]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        
        layoutIfNeeded()
    }
    
    let insigniaView: YRInsigniaView = {
        let insigniaView = YRInsigniaView()
        insigniaView.translatesAutoresizingMaskIntoConstraints = false
        return insigniaView
    }()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension YRProfileTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.insigniaView?.insigniaView.collectionView {
            return 3
        }else if collectionView == self.authView?.insigniaView.collectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.insigniaView?.insigniaView.collectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YRInsigiaViewType.authCell.rawValue, forIndexPath: indexPath) as! AuthCell
            let contentData = self.authIconImagelist[indexPath.item]
            let isAuthed = self.isAuthed[indexPath.item]
            let showPic = isAuthed ? contentData["selected"] : contentData["normal"]
            
            cell.imgV.image = UIImage(named: showPic!)
            cell.titleLb.text = contentData["title"]
            return cell

        }else if collectionView == self.authView?.insigniaView.collectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YRInsigiaViewType.insigniaCell.rawValue, forIndexPath: indexPath) as! InsigniaCell
            return cell
        }

        return UICollectionViewCell()
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        print(#function)
//        if collectionView == self.insigniaView?.insigniaView.collectionView {
//            return CGSizeMake(YRSize.width, YRSize.authHeight - 15)
//        }else if collectionView == self.authView?.insigniaView.collectionView {
//            return CGSizeMake(YRSize.width, YRSize.insigHeight - 18)
//        }
//        return CGSizeMake(YRSize.width, YRSize.authHeight)
//    }
}

private struct YRSize {
    static let width: CGFloat = UIScreen.mainScreen().bounds.width / 5
    static let authHeight: CGFloat = 110 // 与AuthTableViewCell等高
    static let insigHeight: CGFloat = 85 // 与InsigTableViewCell等高
}