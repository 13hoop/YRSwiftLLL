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
            print("////////////////")
        }
    }
    var detailSectionView: YRDetailIfnoView?
    
    var interest: [String] = ["篮球", "haohaoxuexi", "听英语", "de", "看周星驰的电影", "电脑噶松手"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人资料"
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        setUpViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
        detailSectionView!.profile = profile
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUpViews() {
        // scrollView - autoLayout need a assistent view
        let scollBackView: UIScrollView = UIScrollView(frame: view.frame)
//        scollBackView.bounces = false
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
//            /// work
//        detailSection.workView?.editeBtn?.addTarget(self, action: #selector(self.workEditeBtnClicked), forControlEvents: .TouchUpInside)
//        detailSection.workView?.collectionView?.dataSource = self
//            /// wealth
//        detailSection.wealthView?.collectionView?.dataSource = self
//        detailSection.wealthView?.editeBtn?.addTarget(self, action: #selector(self.wealthEditeBtnClicked), forControlEvents: .TouchUpInside)
            /// sexSkill
        detailSection.sexSkillView?.editeBtn?.addTarget(self, action: #selector(self.sexSkillEditeBtnClicked), forControlEvents: .TouchUpInside)
            /// address
        detailSection.addressView?.editeBtn?.addTarget(self, action: #selector(self.addressEditeBtnClicked), forControlEvents: .TouchUpInside)
        
        
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
                       "V:|-0-[headerSectionView(278)]-0-[detailSection(760)]-0-|",
                       "H:|-0-[detailSection]-0-|"
                       ]
        
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        
        setUpHeadViews(on: headerSectionView)
    }
    private func setUpHeadViews(on father: UIView) {
        
    }
    
    //MARK: ---- action ----
    func locationEditeBtnClicked() {
        print(#function)
    }
    func aboutMeEditeBtnClicked() {
        navigationController?.pushViewController(YRAboutMeEditerViewController(), animated: true)
    }
    func interestEditeBtnClicked() {
        navigationController?.pushViewController(YRInterestViewController(), animated: true)
    }
    func workEditeBtnClicked() {
        print(#function)
    }
    func wealthEditeBtnClicked() {
        navigationController?.pushViewController(YRWealthViewController(), animated: true)
    }
    func sexSkillEditeBtnClicked() {
        print(#function)
    }
    func addressEditeBtnClicked() {
        print(#function)
    }
}

//MARK: collectionViewDataSource
extension YRProfileInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            return self.interest.count;
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            return 5;
//        }else if (collectionView == self.detailSectionView!.workView!.collectionView!) {
//            return 3;
//        }else if (collectionView == self.detailSectionView!.wealthView!.collectionView!) {
//            return 3;
        }
        
        return 0;
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
            return cell
//        }else if(collectionView ==  self.detailSectionView!.workView!.collectionView!) {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
//            cell.backgroundColor = UIColor.randomColor()
//            return cell
//        }else if(collectionView ==  self.detailSectionView!.wealthView!.collectionView!) {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
//            cell.backgroundColor = UIColor.randomColor()
//            return cell
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
