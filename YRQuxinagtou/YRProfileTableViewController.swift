//
//  YRProfileTableViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileTableViewController: UITableViewController {

    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nickNameLb: UILabel!
    @IBOutlet var photosImgVs: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        tableView.backgroundView? = v
        
        tableView.tableFooterView = UIView()
        tabBarController?.hidesBottomBarWhenPushed = true
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("son: \(self)")
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
            
            // 为何枚举用不了？？？？
            let cell = YRInsigniaViewCell(style: .Default, reuseIdentifier: String(YRInsigniaStyle.authentication))
            return cell
            
        case 3 where indexPath.row == 1:
            print("  勋章  ")
            return YRInsigniaViewCell(style: .Default, reuseIdentifier: String(YRInsigniaStyle.insignia))
        default:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 2 where indexPath.row == 1:
            return 102.0
        case 3 where indexPath.row == 1:
            return 102.0
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
                navigationController?.pushViewController(YRProfileInfoViewController(), animated: true)
                parentViewController!.hidesBottomBarWhenPushed = false
            default:
                parentViewController!.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(YRUserAlbumViewController(), animated: true)
                parentViewController!.hidesBottomBarWhenPushed = false
            }
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
        setUpViews(insignStyle: YRInsigniaStyle(rawValue: reuseIdentifier!)!)
    }
    
    private func setUpViews(insignStyle style: YRInsigniaStyle) {
        
        let insigniaView = YRInsigniaView(frame: CGRectZero, insignStyle: style)
        insigniaView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(insigniaView)
        
        let viewsDict = ["insigniaView" : insigniaView]
        let vflDict = ["H:|-0-[insigniaView]-0-|",
                       "V:|-0-[insigniaView]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}