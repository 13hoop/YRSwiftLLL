//
//  YRHomeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHomeViewController: UIViewController {


    var meetModel: MeetModel? {
        didSet {
            
        }
    }
    let photoArr = [UIImage]()

    var headerSectionView: YRBannerView?
    var detailSectionView: YRDetailIfnoView?
    var interest: [String] = ["篮球", "haohaoxuexi", "听英语", "de", "看周星驰的电影", "电脑噶松手"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }

    func upDateUI(data data: Profile) {
        
    }
    
    private func loadData() {
        YRService.requiredMeet(success: { [weak self] result in
            if let data = result as? [String: AnyObject] {
                self?.meetModel = MeetModel(fromJSONDictionary: data)
            }
        }, fail: { error in
            print("requrie meet data error: \(error)")
        })
    }
    private func setUpViews() {
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
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
        
        // detailSection
        let detailSection = YRDetailIfnoView(frame: view.frame)
        /// location
        detailSection.locationView?.editeBtn.hidden = true
        detailSection.aboutMeView?.detailCollectionView?.dataSource = self
        /// aboutMe
        detailSection.aboutMeView?.editeBtn.hidden = true
        /// interest
        detailSection.interestView?.editeBtn.hidden = true
        detailSection.interestView?.flowCollectionView?.dataSource = self
        detailSection.interestView?.flowCollectionView?.delegate = self
        /// sexSkill
        detailSection.sexSkillView?.editeBtn.hidden = true
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
    
        //        let metrics = [ "detailTotalHeight" : "\(460 + (aboutMeInfoList?.count)! * 40)"]
        let metrics = [ "detailTotalHeight" : "\(660 + (9 * 40))"]
        
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: metrics, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
}

//MARK: collectionViewDataSource
extension YRHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == self.headerSectionView?.collectionView) {
            let vc = YRAlbumLargePhotoViewController()
            vc.photoUrls = []
            vc.showIndexPath = indexPath
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            return self.interest.count;
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            return 9;
        }else if (collectionView == self.headerSectionView?.collectionView) {
            return 5;
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
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BannerCell", forIndexPath: indexPath) as! BannerCell
            cell.backgroundColor = UIColor.randomColor()
            
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
