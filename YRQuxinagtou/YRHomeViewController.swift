//
//  YRHomeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

private let identifer = "cell"
class YRHomeViewController: UIViewController {

    var index: Int = 0
    
    var meetModel: MeetModel? {
        didSet {
        
        }
    }
    
    var tempProfile: Profile?
    var profile: Profile? {
        didSet {

            print("  updateUI here with data: \n \(profile) ")
            // resume
            detailSectionView?.resumeView?.titleLb.text = profile?.nickname
            if let gender = profile?.gender_name , let age = profile?.age {
                let info = gender + "," + age
                detailSectionView?.resumeView?.resumeInfo.text = info + " "
                if let zodiac = profile?.zodiac_sign {
                    detailSectionView?.resumeView?.resumeInfo.text = info + zodiac
                }
            }
            
            // relation
//            self.headerSectionView?.rightFuncBtn.selected = 
            
            // auth
            
            // location
            detailSectionView?.locationView?.discripLb.text = profile?.province
            
            // insign
            
            // aboutMe
            if let bio = profile?.bio {
                self.aboutMenBioInfo = bio
            }
            
            if let about_me = profile?.about_me {
                self.aboutMeInfoList = about_me
            }
            
            // interest
            if let intr = profile?.interests {
                self.interest = intr
            }
            
            // recentImages
            imageRecent = profile?.recent_images
        }
    }
        
    var imageRecent: [NSURL]? = [] {
        didSet {
            
            if let images = imageRecent {
                self.headerSectionView?.totalLb.text = "1/" + "\(images.count)"
            }
            self.headerSectionView?.collectionView.reloadData()
        }
    }
    
    var isAuthed: [Bool] = [true, false, false, false, false]

    var aboutMenBioInfo: String = "" {
        didSet {
            self.detailSectionView?.aboutMeView?.discriptionLb.text = aboutMenBioInfo == "" ? "还没有此项信息" : aboutMenBioInfo
        }
    }
    var aboutMeInfoList: [ProfileAboutMe] = [] {
        didSet {
            self.detailSectionView?.aboutMeView?.detailCollectionView?.reloadData()
        }
    }

    var interest: [String] = [] {
        didSet {
            self.detailSectionView?.interestView?.flowCollectionView?.reloadData()
        }
    }
    
    var headerSectionView: YRBannerView?
    var detailSectionView: YRHomeDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    private func updateUI() {

        index += 1
        print(index)
        
        if index >= 4 {
            loadData()
        }
        
        profile = meetModel?.meet[index]
    }
    
    private func loadData() {
        index = 0
        YRService.requiredMeet(success: { [weak self] result in
            if let data = result as? [String: AnyObject] {
                self?.meetModel = MeetModel(fromJSONDictionary: data)
                self?.profile = self?.meetModel?.meet[0]
            }
        }, fail: { error in
            print("requrie meet data error: \(error)")
        })
    }
    private func setUpViews() {
        view.backgroundColor = .whiteColor()
        // scrollView - autoLayout need a assistent view
        let scollBackView: UIScrollView = UIScrollView(frame: view.frame)
        view.addSubview(scollBackView)
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scollBackView.addSubview(containerView)
        
        // headerSection
        let headerSectionView = YRBannerView()
        headerSectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerSectionView)
        self.headerSectionView = headerSectionView
        headerSectionView.collectionView.dataSource = self
        headerSectionView.collectionView.delegate = self
        let layout = headerSectionView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0.0
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 500)
        
        headerSectionView.leftFuncBtn.setImage(UIImage(named: "dislike"), forState: .Normal)
        headerSectionView.leftFuncBtn.addTarget(self, action: #selector(disLikeBtnClicked(_:)), forControlEvents: .TouchUpInside)
        headerSectionView.rightFuncBtn.setImage(UIImage(named: "fs_like"), forState: .Normal)
        headerSectionView.rightFuncBtn.setImage(UIImage(named: "fs_liked"), forState: .Highlighted)
        headerSectionView.rightFuncBtn.setImage(UIImage(named: "fs_likest"), forState: .Selected)
        headerSectionView.rightFuncBtn.addTarget(self, action: #selector(likeBtnClicked(_:)), forControlEvents: .TouchUpInside)

        
        // detailSection
        let detailSection = YRHomeDetailView(frame: view.frame)
        detailSection.resumeView?.titleLb.text = "JASON" // resume
        detailSection.resumeView?.resumeInfo.text = "nan, 22sui"
        detailSection.resumeView?.collectionView.dataSource = self
        detailSection.locationView?.titleLb.text = "生活在" // location
        detailSection.locationView?.editeBtn.hidden = true
        detailSection.insigniaView?.titleLb.text = "徽章" // insignia
        detailSection.insigniaView?.collectionView?.dataSource = self
        detailSection.aboutMeView?.titleLb.text = "关于我" // aboutMe
        detailSection.aboutMeView?.detailCollectionView?.dataSource = self
        detailSection.interestView?.titleLb.text = "兴趣爱好" // interest
        detailSection.interestView?.flowCollectionView?.dataSource = self
        detailSection.interestView?.flowCollectionView?.delegate = self

        detailSection.blackListBtn.addTarget(self, action: #selector(addBlackListBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.claimsBtn.addTarget(self, action: #selector(claimsBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.backgroundColor =  UIColor.whiteColor()
        detailSection.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(detailSection)
        self.detailSectionView = detailSection
        
        let viewsDict = [
            "scollBackView" : scollBackView,
            "containerView" : containerView,
            "headerSectionView" : headerSectionView,
            "detailSection" : detailSection
        ]
        let vflDict = [
            "H:|-0-[containerView(scollBackView)]-0-|",
            "V:|-(-20)-[containerView]-0-|",
            "H:|-0-[headerSectionView]-0-|",
            "V:|-0-[headerSectionView(500)]-0-[detailSection(detailTotalHeight)]-0-|",
            "H:|-0-[detailSection]-0-|"
        ]
    
        // let metrics = [ "detailTotalHeight" : "\(460 + (aboutMeInfoList?.count)! * 40)"]
        let metrics = [ "detailTotalHeight" : "\(630 + (9 * 30))"]
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: metrics, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    // MARK:Action
    func disLikeBtnClicked(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            sender.transform = CGAffineTransformScale(sender.transform, 1.1, 1.1)
        }) { [weak self] (_) in
            sender.transform = CGAffineTransformIdentity
            self?.updateUI()
        }
    }

    func likeBtnClicked(sender: UIButton) {
        headerSectionView?.rightFuncBtn.setImage(UIImage(named: "fs_liked"), forState: .Normal)
        tempProfile = meetModel?.meet[index]
        print(tempProfile?.nickname)

        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            sender.transform = CGAffineTransformScale(sender.transform, 1.1, 1.1)
            }) { [weak self] (_) in
                sender.transform = CGAffineTransformIdentity
                self?.updateUI()
                self?.headerSectionView?.rightFuncBtn.setImage(UIImage(named: "fs_like"), forState: .Normal)
        }

        let uuid: String = (tempProfile?.uuid)!
        let param: [String: String] = [
            "uuid" : uuid
        ]
        
        YRService.addLike(userId: param, success: { result in
            print(result)
            }, fail: { error in
            print("add like error: \(error)")
        })
    }
    
    func addBlackListBtnClicked() {

        print(#function)
        
        tempProfile = meetModel?.meet[index]
        let uuid: String = (tempProfile?.uuid)!
        let param = ["uuid": uuid]
        YRService.addToBlackList(data: param, success: {[weak self] _ in
            let alertView: UIAlertView = UIAlertView(title: "已将\((self?.tempProfile?.nickname)!)拉黑", message: "您可以在“我的页面－黑名单”条目中，解除拉黑操作！", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            self?.updateUI()
        }, fail: { error in
            print(" add to blacklist error\(error)")
        })
    }
    
    func claimsBtnClicked() {
        
        self.navigationController?.navigationBar.hidden = false
        tempProfile = meetModel?.meet[index]
        updateUI()
        
        let uuid: String = (tempProfile?.uuid)!
        let vc = YRClaimViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.userId = uuid
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: collectionViewDataSource
extension YRHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == self.headerSectionView?.collectionView) {
            let vc = YRAlbumLargePhotoViewController()
            vc.photoUrls = self.imageRecent
            vc.showIndexPath = indexPath
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.detailSectionView!.resumeView!.collectionView) {
            return self.isAuthed.count;
        }else if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let backLb = collectionView.backgroundView as! UILabel
            if self.interest.isEmpty {
                backLb.text = "还没有添加兴趣"
            }
            return self.interest.count;
        }else if (collectionView == self.detailSectionView!.insigniaView!.collectionView) {
            return 5;
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            return 9;
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let backLb = collectionView.backgroundView as! UILabel
            if self.imageRecent!.isEmpty {
                backLb.text = "还没有可展示的图片"
            }
            return self.imageRecent!.count
        }
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.detailSectionView!.resumeView!.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AuthTagCell", forIndexPath: indexPath) as! AuthTagCell
            return cell
        }else if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlowUnitViewCell", forIndexPath: indexPath) as! FlowUnitViewCell
            cell.titleLb.text = self.interest[indexPath.item]
            return cell
            
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
            if self.aboutMeInfoList.count > 0 {
                
                let model = self.aboutMeInfoList[indexPath.item]
                if let name = model.name {
                    cell.titleLb.text = name + ":"
                } else {
                    cell.titleLb.text = " _ :"
                }
                cell.infoLb.text = model.content
            }
            return cell
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BannerCell", forIndexPath: indexPath) as! BannerCell
            let model = self.imageRecent![indexPath.row]
            cell.photoImgV.kf_showIndicatorWhenLoading = true
            cell.photoImgV.kf_setImageWithURL(model)
            return cell
        }else if (collectionView == self.detailSectionView!.insigniaView!.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YRInsigiaViewType.insigniaCell.rawValue, forIndexPath: indexPath) as! InsigniaCell
            return cell
        }
        return UICollectionViewCell()
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let word = self.interest[indexPath.item] as String
            let size = word.stringConstrainedSize(UIFont.systemFontOfSize(17.0))
            let itemSize = CGSizeMake(size.width + 16 + 10, size.height + 16 )
            return itemSize
        }else {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            return layout.itemSize
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    
        let width = UIScreen.mainScreen().bounds.width
        let page = Int(scrollView.contentOffset.x / width)
        self.headerSectionView?.totalLb.text = "\(page + 1)" + "/" + "\(self.imageRecent!.count)"
    }
}
