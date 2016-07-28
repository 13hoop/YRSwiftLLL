//
//  YRHomeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHomeViewController: UIViewController {

    var meetModel: MeetModel?
    var profile: Profile? {
        didSet {
            // using data updateUI here
            print("  updateUI here  ")
        }
    }
    
    let photoArr = [UIImage]()

    var headerSectionView: YRBannerView?
    var detailSectionView: YRHomeDetailView?
    
    var interest: [String] = ["篮球", "haohaoxuexi", "听英语", "de", "看周星驰的电影", "电脑噶松手"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }

//    func updateUI(data data: Profile) {
//        
//    }
    
    private func loadData() {
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
        let metrics = [ "detailTotalHeight" : "\(630 + (9 * 40))"]
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
        if (collectionView == self.detailSectionView!.resumeView!.collectionView) {
            return 5;
        }else if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            return self.interest.count;
        }else if (collectionView == self.detailSectionView!.insigniaView!.collectionView) {
            return 5;
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            return 9;
        }else if (collectionView == self.headerSectionView?.collectionView) {
            return 5;
        }

        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.detailSectionView!.resumeView!.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AuthTagCell", forIndexPath: indexPath) as! AuthTagCell
            return cell
        }else if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlowUnitViewCell", forIndexPath: indexPath) as! FlowUnitViewCell
            cell.backgroundColor = UIColor.randomColor()
            cell.titleLb.text = self.interest[indexPath.item]
            return cell
            
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
            return cell
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BannerCell", forIndexPath: indexPath) as! BannerCell
            cell.backgroundColor = UIColor.randomColor()
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
