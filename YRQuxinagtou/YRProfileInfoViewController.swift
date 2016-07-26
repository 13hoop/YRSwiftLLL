//
//  YRProfileInfoViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileInfoViewController: UIViewController {

    var profile: Profile? {
        didSet {
            print("-- ProfileVC setter here --\n \(profile?.interests)")
            self.aboutMeInfoList = profile?.about_me
            self.interest = (profile?.interests)!
        }
    }
    
    var updateUI:[String] = []
    
    var headerSectionView: YRHeaderView?
    var detailSectionView: YRDetailIfnoView?
    
    var interest: [String] = [] {
        didSet {
            self.detailSectionView?.interestView?.flowCollectionView?.reloadData()
        }
    }
    
    var aboutMeInfoList: [ProfileAboutMe]? {
        didSet {
            self.detailSectionView?.aboutMeView?.detailCollectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人资料"
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        setUpViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        detailSectionView?.profile = profile
        headerSectionView?.profile = profile
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
        detailSection.locationView?.editeBtn?.addTarget(self, action: #selector(self.locationEditeBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.aboutMeView?.detailCollectionView?.dataSource = self
            /// aboutMe
        detailSection.aboutMeView?.editeBtn?.addTarget(self, action: #selector(self.aboutMeEditeBtnClicked), forControlEvents: .TouchUpInside)
            /// interest
        detailSection.interestView?.editeBtn?.addTarget(self, action: #selector(self.interestEditeBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.interestView?.flowCollectionView?.dataSource = self
        detailSection.interestView?.flowCollectionView?.delegate = self
            /// sexSkill
        detailSection.sexSkillView?.editeBtn?.addTarget(self, action: #selector(self.sexSkillEditeBtnClicked), forControlEvents: .TouchUpInside)

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


        let metrics = [ "detailTotalHeight" : "\(460 + (aboutMeInfoList?.count)! * 40)"]
        
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: metrics, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    //MARK: ---- action ----
    func locationEditeBtnClicked() {
        print(#function)
    }
    func aboutMeEditeBtnClicked() {
        let vc = YRAboutMeEditerViewController()
        vc.editPageArr = self.profile?.editPageArr
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
            return self.aboutMeInfoList!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlowUnitViewCell", forIndexPath: indexPath) as! FlowUnitViewCell
            cell.backgroundColor = UIColor.randomColor()
            cell.titleLb.text = self.interest[indexPath.item]
            return cell

        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
            cell.backgroundColor = UIColor.randomColor()
            let model = self.aboutMeInfoList![indexPath.item]
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
