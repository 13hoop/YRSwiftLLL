//
//  YRMessageViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import CoreData

class YRMessageViewController: UIViewController {
    
    
    // updates data : chat user list data
//    var updates
    
    var client: AVIMClient?
    private let defaultTitles = ["访客", "配对" , "最爱"]
    private let defaultInfo = ["看看最近谁来过", "与你互相喜欢的会员", "看看最爱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
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
    
    private var layout: UICollectionViewFlowLayout?
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(YRChartListCell.self, forCellWithReuseIdentifier: "YRChartListCell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
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
        }else {
            let vc = YRConversationViewController()
            let uuid = YRUserDefaults.userUuid
            let nickName = uuid
            
            let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
            
            self.client = AVIMClient(clientId: nickName)
            client!.delegate = vc
            client!.openWithCallback { (succeede, error) in
                if (error == nil) {
                    self.client!.createConversationWithName("\(nickName)与\(chatWithName)的对话", clientIds: [chatWithName], callback: {[weak vc] (conversation, error) in
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = cell as? YRChartListCell {
            if indexPath.item < 3 {
                cell.imgV.backgroundColor = YRConfig.systemTintColored
                cell.titleLb.text = self.defaultTitles[indexPath.row]
                cell.infoLb.text = self.defaultInfo[indexPath.row]
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + 3;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRChartListCell", forIndexPath: indexPath)
        return cell
    }
}

//: TODO
//extension YRMessageViewController: ManagedObjectContextSettable, DataProviderDelegate {
//    // you can set if you wish
//    // but here, is only getter used
//    var managedObjectContext: NSManagedObjectContext! {
//        set {
//            self.managedObjectContext = newValue
//        }
//        get {
//            return AppDelegate().managedObjcetContext
//        }
//    }
//
//    private func setDataController() {
//        let request = YRChatUser.sortedFetchRequest
//        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: NSIsNilTransformerName, cacheName: nil)
//        let dataProvider = FetchedResultsDataProvider(fetchedResultController: frc, delegate: self)
//    }
//    
//    // should reload data
//    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?) {
//        self.processUpdates(updates)
//    }
//    
//    func processUpdates(updates: [DataProviderUpdate<Object>]?) {
//        
//        guard let updates = updates else {
//            return self.collectionView.reloadData()
//        }
//        
//        self.collectionView.performBatchUpdates({ 
//            for obj in updates {
//                switch obj {
//                case .Insert(let indexPath):
//                    self.collectionView.insertItemsAtIndexPaths([indexPath])
//                case .Update(let indexPath, let object):
//                    
//                    guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? YRChartListCell else {
//                        fatalError("cell type not find ")
//                    }
//                    cell.configuireForData(object)
//                case .Move(let indexPath, let newIndexPath):
//                    print("do not allow move")
//                
//                case .Delete(let indexPath):
//                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
//                }
//            }
//        }, completion: nil)
//    }
//}




