//
//  YRProfileInfoViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileInfoViewController: UIViewController {
    
    // case setter while view didn't ready
    var tempProfile: Profile?
    var profile: Profile? {
        didSet {
            
            print("  updateUI here with data: \n ")
        /*-- headerSection --*/
            headerSectionView?.nameLb.text = profile?.nickname
            headerSectionView?.titleLb.text = "\(profile!.gender_name! as String), \(profile!.age! as String)"

            
            if let avatarStr = profile?.avatar {

                let avatarUrlOp: NSURL? = NSURL(string: avatarStr)
                guard let avatarUrl: NSURL = avatarUrlOp
                    else {
                    print("Oops! url is nil ....  ")
                    return
                }

                headerSectionView?.avateBtn.kf_setBackgroundImageWithURL(avatarUrl, forState: .Normal)
                headerSectionView?.avateBtn.kf_setBackgroundImageWithURL(avatarUrl, forState: .Highlighted)

                UIImage.loadImageUsingKingfisher(avatarUrl) { [weak self](image, error, cacheType, imageURL) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if let img = image {
                            self?.headerSectionView?.backImgV.image = img.applyBlurWithRadius(5, tintColor: UIColor(white: 0.11, alpha: 0.1), saturationDeltaFactor: 1.8)
                        }
                    })
                }
            }
            
        /*-- detailSection --*/
            // location
            detailSectionView?.locationView?.discripLb.text = profile?.province
            print("  setter location TODO : \(detailSectionView?.locationView?.discripLb.text) ")

            // aboutMe
            self.aboutMenBioInfo = (profile?.bio)!
            self.aboutMeInfoList = (profile?.about_me)!

            // interest
            interest = (profile?.interests)!
        }
    }

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

    var isUpdated: Bool = false
    var headerSectionView: YRHeaderView?
    var detailSectionView: YRDetailIfnoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self)
        title = "个人资料"
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        setUpViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !isUpdated {
            self.profile = tempProfile
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUpViews() {
        // scrollView - autoLayout need a assistent view
        let scollBackView: UIScrollView = UIScrollView(frame: view.frame)
        scollBackView.delegate = self
        view.addSubview(scollBackView)
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scollBackView.addSubview(containerView)
        
        // headerSection
        let headerSectionView = YRHeaderView()
        headerSectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerSectionView)
        self.headerSectionView = headerSectionView
        
        // detailSection
        let detailSection = YRDetailIfnoView(frame: view.frame)
        /// location
        detailSection.locationView?.titleLb.text = "当前位置"
        detailSection.locationView?.editeBtn.addTarget(self, action: #selector(self.locationEditeBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.aboutMeView?.detailCollectionView?.dataSource = self
        /// aboutMe
        detailSection.aboutMeView?.titleLb.text = "关于我"
        detailSection.aboutMeView?.editeBtn.addTarget(self, action: #selector(self.aboutMeEditeBtnClicked), forControlEvents: .TouchUpInside)
        /// interest
        detailSection.interestView?.titleLb.text = "兴趣爱好"
        detailSection.interestView?.editeBtn.addTarget(self, action: #selector(self.interestEditeBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.interestView?.flowCollectionView?.dataSource = self
        detailSection.interestView?.flowCollectionView?.delegate = self
        /// sexSkill
        detailSection.sexSkillView?.titleLb.text = "性能力"
        detailSection.sexSkillView?.editeBtn.addTarget(self, action: #selector(self.sexSkillEditeBtnClicked), forControlEvents: .TouchUpInside)
        
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
            "V:|-0-[headerSectionView(300)]-0-[detailSection(detailTotalHeight)]-0-|",
            "H:|-0-[detailSection]-0-|"
        ]
        
        
        let metrics = [ "detailTotalHeight" : "\(450 + 9 * 30)"]
        
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: metrics, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private func loadProfileData() {
        YRService.requiredProfile(success: { [weak self] result in
            if let data = result!["data"] as? [String: AnyObject] {
                let profile = Profile(fromJSONDictionary: data)
                self?.profile = profile
            }
        }) { (error) in
            print("\(#function) error: \(error)")
        }
    }
    
    //MARK: ---- action ----
    func locationEditeBtnClicked() {
        print(#function)
        let vc = YREditMoreViewController()
        vc.modelArr = ["北京","上海","浙江","海南","湖北","湖南","澳门","甘肃","福建","西藏","贵州","辽宁","重庆","陕西","青海","香港","河南","河北","江西","云南","内蒙古","台湾","吉林","四川","天津","宁夏","安徽","山东","山西","广东","广西","新疆","江苏","黑龙江","海外"]
        vc.callBack = {[weak self] (text: String?, selectedIndex: NSIndexPath) in

            
            print("  🛬🛬🛬 localion here is the callback: \(text) - \(selectedIndex)")
            
//            let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
//            cell.disLb.text = text
//            if  text != self?.defaultBirthplace {
//                self?.updateList["birthplace"] = text
//                self?.isUpdated = true
//                self?.updateProfile()
//            }else {
//                self?.isUpdated = false
//            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func aboutMeEditeBtnClicked() {
        let vc = YRAboutMeEditerViewController()
        vc.editPageArr = self.profile?.editPageArr
        vc.defaultBio = self.profile?.bio
        vc.defaultHeight = self.profile?.height
        vc.defaultNation = self.profile?.nation
        vc.defaultBirthplace = self.profile?.birthplace
        
        vc.callBack = {[weak self] isUpdated in
            self?.isUpdated = isUpdated
            if isUpdated {
                print("   reload new data from service   ")
                self?.loadProfileData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func interestEditeBtnClicked() {
        let vc = YRInterestViewController()
        vc.interest = (self.profile?.interests)!
        navigationController?.pushViewController(vc, animated: true)
    }
    func sexSkillEditeBtnClicked() {
        print(#function)
    }
}

//MARK: collectionViewDataSource
extension YRProfileInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!) {
            let backLb = collectionView.backgroundView as! UILabel
            if self.interest.isEmpty {
                backLb.text = "您还没有添加兴趣"
            }
            return self.interest.count
        }else {
            return self.aboutMeInfoList.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlowUnitViewCell", forIndexPath: indexPath) as! FlowUnitViewCell
            cell.titleLb.text = self.interest[indexPath.item]
            return cell

        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
            let model = self.aboutMeInfoList[indexPath.item]
            cell.titleLb.text = model.name! + ":"
            cell.infoLb.text = model.content
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let word = self.interest[indexPath.item] as String
        let size = word.stringConstrainedSize(UIFont.systemFontOfSize(17.0))
        let itemSize = CGSizeMake(size.width + 16 + 10, size.height + 16 )
        return itemSize
    }
}

extension YRProfileInfoViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
