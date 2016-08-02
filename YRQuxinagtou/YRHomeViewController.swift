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
    
    var meetModel: MeetModel?
    
    var tempProfile: Profile?
    var profile: Profile? {
        didSet {

//            print("  updateUI here with data: \n \(profile) ")

            // resume
            detailSectionView?.resumeView?.titleLb.text = profile?.nickname
            let info = (profile?.gender_name)! + "," + (profile?.age)!
            detailSectionView?.resumeView?.resumeInfo.text = info + " " + (profile?.zodiac_sign)!
            
            // auth
            
            // location
            detailSectionView?.locationView?.discripLb.text = profile?.province            
            // insign
            
            // aboutMe
            self.aboutMenBioInfo = (profile?.bio)!
            self.aboutMeInfoList = (profile?.about_me)!

            // interest
            interest = (profile?.interests)!
            
            // recentImages
            imageRecent = profile?.recent_images
        }
    }
        
    var imageRecent: [NSURL]? = [] {
        didSet {
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
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 480)
        headerSectionView.disLikeBtn.addTarget(self, action: #selector(disLikeBtnClicked), forControlEvents: .TouchUpInside)
        headerSectionView.likeBtn.addTarget(self, action: #selector(likeBtnClicked), forControlEvents: .TouchUpInside)

        
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
        detailSection.sexSkillView?.titleLb.text = "性能力" // sexSkill
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
    
    // Action
    func disLikeBtnClicked() {
        updateUI()
    }

    func likeBtnClicked() {
        print(" -- \(index)")
        tempProfile = meetModel?.meet[index]
        print(tempProfile?.nickname)

        updateUI()

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
    }
    
    func claimsBtnClicked() {
        print(#function)
        tempProfile = meetModel?.meet[index]
        print(tempProfile?.nickname)
        
//        updateUI()
        
        let uuid: String = (tempProfile?.uuid)!
        let param: [String: String] = [
            "uuid" : uuid
        ]
        let vc = YRClaimViewController()
        vc.userId = param
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
                cell.titleLb.text = model.name! + ":"
                cell.infoLb.text = model.content
            }
            return cell
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BannerCell", forIndexPath: indexPath) as! BannerCell
            let model = self.imageRecent![indexPath.row]
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
}
