//
//  YRGuideViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/9.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRGuideViewController: UIViewController {

    
    private let imagesName = ["guider001", "guider001", "guider001"]
    private let titles = ["欢迎加入趣相投", "与帅哥美女快速配对", "开放的交友心态认真的交友态度"]
    private let infoes = ["在这里你可以只跟感兴趣的人 聊天、交朋友、约会甚至结婚", "给有眼缘的人点❤️    给没感觉的人点 X", ""]
    
    lazy var loginBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.setTitle("登陆", forState: .Normal)
        view.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        view.setTitleColor(YRConfig.mainTextColored, forState: .Normal)
        view.addTarget(self, action: #selector(loginBtnClicked(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var registBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.setTitle("注册", forState: .Normal)
        view.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        view.setTitleColor(YRConfig.mainTextColored, forState: .Normal)
        view.addTarget(self, action: #selector(registerBtnClicked(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var glancedBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.setTitle("随便看看", forState: .Normal)
        view.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        view.backgroundColor = YRConfig.themeTintColored
        view.addTarget(self, action: #selector(glancedBtnClicked(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var pageControl: UIPageControl = {
        let view = UIPageControl(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.registerClass(YRGuideCell.self, forCellWithReuseIdentifier: "YRGuideCell")
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.pagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        automaticallyAdjustsScrollViewInsets = false
        setUpViews()
    }
    
    private func setUpViews() {
        let assistView = UIView()
        assistView.translatesAutoresizingMaskIntoConstraints = false
        assistView.backgroundColor = YRConfig.plainBackgroundColored
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(registBtn)
        view.addSubview(loginBtn)
        view.addSubview(assistView)
        view.addSubview(glancedBtn)
        
        let viewsDict = ["collectionView" : collectionView,
                         "pageControl" : pageControl,
                         "registBtn" : registBtn,
                         "loginBtn" : loginBtn,
                         "glancedBtn" : glancedBtn,
                         "assistView" : assistView]
        let vflDict = ["H:|-45-[collectionView]-45-|",
                       "V:|-0-[collectionView]-160-|",
                       "V:[assistView(20)]-[glancedBtn(44)]|",
                       "H:|[glancedBtn]|",
                       "H:|-[loginBtn]-[assistView(1)]-[registBtn]-|",
                       "V:[collectionView]-(-20)-[pageControl(20)]"]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        view.addConstraint(NSLayoutConstraint(item: assistView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0))
        view.layoutIfNeeded()

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: viewsDict))
        layout.scrollDirection = .Horizontal
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
    }
    
    //MARK: Action
    func loginBtnClicked(sender: UIButton) {
        print(#function)
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("YRLogInViewController") as! YRLogInViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    func registerBtnClicked(sender: UIButton) {
        print(#function)
        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterViewController") as! YRRegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func glancedBtnClicked(sender: UIButton) {
        print(#function)
    }
}

extension YRGuideViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 3
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRGuideCell", forIndexPath: indexPath) as! YRGuideCell
        cell.imgV.image = UIImage(named: self.imagesName[indexPath.item])
        cell.titleLb.text = self.titles[indexPath.item]
        cell.infoLb.text = self.infoes[indexPath.item]
        return cell
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let xPos = scrollView.contentOffset.x + 10
        self.pageControl.currentPage = (Int)(xPos / width)
    }
}

// guideCell
class YRGuideCell: UICollectionViewCell {
    let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.textColor = YRConfig.themeTintColored
        view.font = UIFont.systemFontOfSize(20.0)
        view.text = "欢迎加入趣相投"
        view.textAlignment = .Center
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let infoLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.textColor = YRConfig.mainTextColored
        view.font = UIFont.systemFontOfSize(17.0)
        view.textAlignment = .Center
        view.numberOfLines = -1
        view.text = "在这里你可以只跟感兴趣的人 聊天、交朋友、约会甚至结婚"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(titleLb)
        contentView.addSubview(infoLb)
        contentView.addSubview(imgV)
        
        let viewsDict = ["titleLb" : titleLb,
                         "infoLb" : infoLb,
                         "imgV" : imgV]
        let vflDict = ["H:|-0-[imgV]-0-|",
                       "V:[titleLb]-12-[infoLb]-30-[imgV]-0-|"]
        imgV.addConstraint(NSLayoutConstraint(item: imgV, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: imgV, attribute: .Height, multiplier: 1.0, constant: 0))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [.AlignAllRight, .AlignAllLeft], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [.AlignAllRight, .AlignAllLeft], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

