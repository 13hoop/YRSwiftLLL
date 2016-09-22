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
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(YRChartListCell.self, forCellReuseIdentifier: "YRChartListCell")
        tableView.registerClass(YRChartCategoryCell.self, forCellReuseIdentifier: "YRChartCategoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.rowHeight = 76.0
        tableView.backgroundColor = .whiteColor()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.notificationToken?.stop()
    }
    
    private func setUpView() {
        view.addSubview(tableView)
        
        let viewsDict = ["tableView" : tableView]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-0-[tableView]-0-|"]
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
            
            guard let tableView = self?.tableView else { return }
            
            switch changes{
            case .Initial:
                tableView.reloadData()
            case .Update(_, let deletions, let insertions, let modifications):
                print(" 🙄🙄🙄🙄 should update data at \(insertions) \(deletions) \(modifications)")
                tableView.beginUpdates()
                
                tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0 + 3 , inSection: 0) },
                    withRowAnimation: .Automatic)
                
                tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0 + 3 , inSection: 0) },
                    withRowAnimation: .Automatic)
                
                tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0 + 3, inSection: 0) },
                    withRowAnimation: .Automatic)
                
                tableView.endUpdates()
            case .Error(let error):
                fatalError("\(error)")
            }
        })
    }
}

//MARK: UITableViewDataSource
extension YRMessageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < 3 {
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
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3 {

            // for test
            let vc = YRConversationViewController()
            let uuid = YRUserDefaults.userUuid
            let nickName = uuid
            let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
            
            // add test model
            let model = YRChatModel()
            model.uuid = chatWithName
            model.name = chatWithName
            model.numStr = "0"
            model.time = NSDate.coventeNowToDateStr()
            let infoDict = ["ssssss" : "test chat"]
            
            guard let client = super.client else {
                return
            }
            
            client.openWithCallback { (succeede, error) in
                guard error == nil else {
                    let alertView: UIAlertView = UIAlertView(title: "聊天不可用！", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    return
                }

                client.createConversationWithName("与\(nickName)聊天", clientIds: [uuid], attributes: infoDict, options: [AVIMConversationOption.Unique, AVIMConversationOption.None], callback:{[weak vc] (conversation, error) in
                    
                    guard error == nil else { return }
                    
                    model.converstationID = conversation.conversationId
                    print(conversation.conversationId)
                    // save to local
                    self.addToRealm(model)

                    vc?.conversation = conversation
                    })
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            
//            let vc = YRConversationViewController()
//            let nickName = YRUserDefaults.userNickname
//            guard let results = self.fetchedResults else {
//                return
//            }
//            let model = results[indexPath.row - 3]
//            let chatWithUuid = model.uuid!
//            let chatWithName = model.name!
//            self.client!.openWithCallback { (succeede, error) in
//                
//                guard error == nil else {
//                    let alertView: UIAlertView = UIAlertView(title: "聊天不可用！", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
//                    alertView.show()
//                    return
//                }
//                // 已经聊过的
//                let query = self.client!.conversationQuery()
//                query?.getConversationById(chatWithUuid, callback: {[weak vc] (conversation, error) in
//                    print(error)
//                    vc?.conversation = conversation
//                })
////                self.navigationController?.pushViewController(vc, animated: true)
//
//                // 想聊天的
//                self.client!.createConversationWithName("\(nickName)与\(chatWithName)的对话", clientIds: [chatWithUuid], callback: {[weak vc] (conversation, error) in
//                    
//                    print("creat converstation \(error)")
//                    vc?.conversation = conversation
//                })
////                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            print(indexPath)
        default:
            return
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        guard indexPath.row > 3 else {
            return .None
        }
        return .Delete
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = self.fetchedResults else {
            return 3
        }
        return result.count + 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("YRChartCategoryCell", forIndexPath: indexPath) as! YRChartCategoryCell
            cell.imgV.backgroundColor = YRConfig.systemTintColored
            cell.titleLb.text = self.defaultTitles[indexPath.row]
            cell.infoLb.text = self.defaultInfo[indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("YRChartListCell", forIndexPath: indexPath) as! YRChartListCell
            guard let results = self.fetchedResults else {
                return cell
            }
            
            guard results.count > 0 else {
                return cell
            }
            
//            if indexPath.row == 3 {
//                let uuid = YRUserDefaults.userUuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
//                let r = super.realm.objects(YRChatModel).filter(" uuid = '\(uuid)'")
//                if let model = r.last {
//                    cell.titleLb.text = model.name
//                    cell.timeLb.text = model.time
//                    cell.infoLb.text = model.lastText
//                    cell.numLb.hidden = model.numStr == "0"
//                    cell.imgV.backgroundColor = .greenColor()
//                    cell.numLb.hidden = false
//                    return cell
//                }
//            }else {
                let model = results[indexPath.row - 3]
                cell.titleLb.text = model.name
                cell.timeLb.text = model.time
                cell.infoLb.text = model.lastText
                cell.numLb.hidden = model.numStr == "0"
                cell.numLb.text = model.numStr
                cell.imgV.kf_showIndicatorWhenLoading = true
                if let urlStr = model.imgStr {
                    
                    guard let url = NSURL(string: urlStr) else  {
                        return cell
                    }
                    UIImage.loadImageUsingKingfisher(url, completion: { (image, error, cacheType, imageURL) in
                        if let img = image {
                            cell.imgV.image = img.resizeWithWidth(60.0)
                        }
                    })
//                }
            }
            return cell
        }
    }
}
