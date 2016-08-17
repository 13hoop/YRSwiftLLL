//
//  YRMessageViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRMessageViewController: UIViewController {
    
    
    var client: AVIMClient?
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
        collectionView.bounces = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.pagingEnabled = true
        return collectionView
    }()
}

//MARK: collectionViewDataSource
extension YRMessageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:   NSIndexPath) {

        let vc = YRConversationViewController()
        let uuid = YRUserDefaults.userUuid
        let nickName = uuid
        
        let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
        
        self.client = AVIMClient(clientId: nickName)
        client!.delegate = vc
        client!.openWithCallback { (succeede, error) in
            
            print(" open converstion successful: \(succeede)")
            
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRChartListCell", forIndexPath: indexPath)
        return cell
    }
}


