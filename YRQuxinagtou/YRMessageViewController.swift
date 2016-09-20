//
//  YRMessageViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloudIM
import RealmSwift

class YRMessageViewController: YRBasicViewController {
    
    private var fetchedResults: Results<YRChatModel>?
    private var notificationToken: NotificationToken?
    private let defaultTitles = ["访客", "配对" , "最爱"]
    private let defaultInfo = ["看看最近谁来过", "与你互相喜欢的会员", "看看最爱"]
    private var layout: UICollectionViewFlowLayout?
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(YRChartListCell.self, forCellWithReuseIdentifier: "YRChartListCell")
        collectionView.registerClass(YRChartCategoryCell.self, forCellWithReuseIdentifier: "YRChartCategoryCell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if tabBarController?.tabBar.hidden == true {
           tabBarController?.tabBar.hidden = false
        }
    }
    private func setUpView() {
        layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .Vertical
        layout?.minimumLineSpacing = 0.0
        layout?.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 76)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
    }
    private func loadData() {
        self.fetchedResults = realm.objects(YRChatModel)
        realmNotify()
    }
    
    private func realmNotify() {
        self.notificationToken = self.fetchedResults?.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            
            guard let collectionView = self?.collectionView else { return }
            
            switch changes{
            case .Initial:
                collectionView.reloadData()
            case .Update(_, _, _, let modifications):
                print(" 🙄🙄🙄🙄 should update data at \(modifications)")
                collectionView.performBatchUpdates({
                    
                    collectionView.reloadItemsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) })

                    }, completion: { _ in
                        collectionView.reloadData()
                        print("---- done -----")
                    })
            case .Error(let error):
                fatalError("\(error)")
            }
        })
    }
}

//MARK: collectionViewDataSource
extension YRMessageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:   NSIndexPath) {
        if indexPath.item < 3 {
            let vc: UIViewController
            
            switch indexPath.row {
            case 0:
                // 访客
                vc = YRVisitorViewController()
            case 1:
                // 配对
                vc = YRMatchedViewController()
            default:
                print("最爱")
                vc = YRConectViewController()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.item == 3 {

            let vc = YRConversationViewController()
            let uuid = YRUserDefaults.userUuid
//            let nickName = uuid
            let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
            
            // add test model
            let model = YRChatModel()
            model.uuid = chatWithName
            model.name = chatWithName
//            model.imgStr =  
            model.lastText = " last text message here "
            model.numStr = "1"
            model.time = "test time"
            try! super.realm.write({
                super.realm.add(model, update: true)
            })

            self.client!.openWithCallback { (succeede, error) in
                if (error == nil) {
                    self.client!.createConversationWithName("text chat", clientIds: [chatWithName], callback: {[weak vc] (conversation, error) in
                        vc?.conversation = conversation
                        })
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    let alertView: UIAlertView = UIAlertView(title: "聊天不可用！", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        }else {
            let vc = YRConversationViewController()
            let nickName = YRUserDefaults.userNickname
            
            guard let results = self.fetchedResults else {
                return
            }
            let model = results[indexPath.item - 3]
            let chatWithUuid = model.uuid!
            let chatWithName = model.name!
            self.client!.openWithCallback { (succeede, error) in
                if (error == nil) {
                    self.client!.createConversationWithName("\(nickName)与\(chatWithName)的对话", clientIds: [chatWithUuid], callback: {[weak vc] (conversation, error) in
                        vc?.conversation = conversation
                        })
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    let alertView: UIAlertView = UIAlertView(title: "聊天不可用！", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = self.fetchedResults else {
            return 4
        }
        return result.count + 3 + 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item < 3 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRChartCategoryCell", forIndexPath: indexPath) as! YRChartCategoryCell
            cell.imgV.backgroundColor = YRConfig.systemTintColored
            cell.titleLb.text = self.defaultTitles[indexPath.row]
            cell.infoLb.text = self.defaultInfo[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRChartListCell", forIndexPath: indexPath) as! YRChartListCell

            guard let results = self.fetchedResults else {
                return cell
            }
            
            guard results.count > 0 else {
                return cell
            }
            
            if indexPath.item == 3 {
                let model = results[4]
                cell.titleLb.text = model.name
                cell.timeLb.text = model.time
                cell.infoLb.text = model.lastText
                cell.numLb.hidden = model.numStr == "0"
                cell.imgV.backgroundColor = .greenColor()
                cell.numLb.hidden = false
                
            }else {
                let model = results[indexPath.item - 4]
                cell.titleLb.text = model.name
                cell.timeLb.text = model.time
                cell.infoLb.text = model.lastText
                cell.numLb.hidden = model.numStr == "0"
                cell.numLb.text = model.numStr
                cell.imgV.kf_showIndicatorWhenLoading = true
                if let urlStr = model.imgStr {
                    let url = NSURL(string: urlStr)!
                    UIImage.loadImageUsingKingfisher(url, completion: { (image, error, cacheType, imageURL) in
                        if let img = image {
                            cell.imgV.image = img.resizeWithWidth(60.0)
                        }
                    })
                }
            }
            return cell
        }
    }
}




