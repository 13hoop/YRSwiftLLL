//
//  YRProfileInfoViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileInfoViewController: UIViewController {

    var detailSectionView: YRDetailIfnoView?
    
    var interest: [String] = ["篮球", "haohaoxuexi", "听英语", "de", "看周星驰的电影", "电脑噶松手"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人资料"
        setUpViews()
    }

    private func setUpViews() {
        // scrollView - autoLayout need a assistent view
        let scollBackView: UIScrollView = UIScrollView(frame: view.frame)
        view.addSubview(scollBackView)
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scollBackView.addSubview(containerView)
        
        // headerSection
        let headerSectionView = UIView()
        headerSectionView.backgroundColor =  UIColor.randomColor()
        headerSectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerSectionView)
        
        // detailSection
        let detailSection = YRDetailIfnoView(frame: view.frame)

        detailSection.aboutMeView!.detailCollectionView!.dataSource = self
        detailSection.interestView?.flowCollectionView?.dataSource = self
        detailSection.interestView?.flowCollectionView?.delegate = self
        
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
                       "V:|-0-[containerView]-0-|",
                       "H:|-0-[headerSectionView]-0-|",
                       "V:|-0-[headerSectionView(278)]-0-[detailSection(1000)]-0-|",
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
}

//MARK: collectionViewDataSource
extension YRProfileInfoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            return self.interest.count;
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
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
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let word = self.interest[indexPath.item] as String
        let size = word.stringConstrainedSize(UIFont.systemFontOfSize(17.0))
        print("\(word)---\(size)")
        let itemSize = CGSizeMake(size.width + 16 + 10, size.height + 16 )
        return itemSize
    }

}
