//
//  YRProfileInfoViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileInfoViewController: UIViewController {

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
        detailSection.collectionView.dataSource = self
        detailSection.backgroundColor =  UIColor.whiteColor()
        detailSection.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(detailSection)

        let viewsDict = ["scollBackView" : scollBackView,
                         "containerView" : containerView,
                         "headerSectionView" : headerSectionView,
                         "detailSection" : detailSection]
        let vflDict = ["H:|-0-[containerView(scollBackView)]-0-|",
                       "V:|-0-[containerView]-0-|",
                       "H:|-0-[headerSectionView]-0-|",
                       "V:|-0-[headerSectionView(278)]-0-[detailSection(1000)]-0-|",
                       "H:|-0-[detailSection]-0-|"]
        
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
extension YRProfileInfoViewController:  UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}