//
//  YRFriendOneViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/26.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YRFriendOneViewController: YRBasicViewController {

    var uuid: String = "" {
        didSet {
            print(uuid)
            YRService.requiredProfile(uuid, success: { [weak self](result) in
                if let data = result!["data"] as? [String: AnyObject] {
                    self?.profile = Profile(fromJSONDictionary: data)
                }
            }, fail: { error in
                print("required friendOne profile error: \(error)")
            })
        }
    }
    
    private var profile: Profile? {
        didSet {
            
            print("  updateUI here with data: \n \(profile) ")
            
            // resume
            detailSectionView?.resumeView?.titleLb.text = profile?.nickname
            
            if let gender = profile?.gender_name , let age = profile?.age {
                let info = gender + "," + age
                detailSectionView?.resumeView?.resumeInfo.text = info + " "
                if let zodiac = profile?.zodiac_sign {
                    detailSectionView?.resumeView?.resumeInfo.text = info + zodiac
                }
            }

            // feel
            if let feel = profile?.feeling {
                switch feel {
                case "0":
                    headerSectionView?.leftFuncBtn.setImage(UIImage(named: "fs_like"), forState: .Normal)
                case "1":
                    headerSectionView?.leftFuncBtn.setImage(UIImage(named: "fs_liked"), forState: .Normal)
                default:
                    headerSectionView?.leftFuncBtn.setImage(UIImage(named: "fs_like"), forState: .Normal)
                }
            }
            
            // favorite
            if let is_favorite = profile?.is_favorite {
//                let imageName = is_favorite ? "fs_liked" : "fs_like"
//                headerSectionView?.leftFuncBtn.setImage(UIImage(named: imageName), forState: .Normal)
            }
            
            // auth
            
            // location
            detailSectionView?.locationView?.discripLb.text = profile?.province
            
            // insign
            
            // aboutMe
            if let bio = profile?.bio {
                self.aboutMenBioInfo = bio
            }
            
            if let about_me = profile?.about_me {
                self.aboutMeInfoList = about_me
            }
            
            // interest
            if let intr = profile?.interests {
                self.interest = intr
            }
            
            // recentImages
            imageRecent = profile?.recent_images
        }
    }
    private var imageRecent: [NSURL]? = [] {
        didSet {
            
            if let images = imageRecent {
                self.headerSectionView?.totalLb.text = "1/" + "\(images.count)"
            }
            self.headerSectionView?.collectionView.reloadData()
        }
    }
    private var isAuthed: [Bool] = [true, false, false, false, false]
    private var aboutMenBioInfo: String = "" {
        didSet {
            self.detailSectionView?.aboutMeView?.discriptionLb.text = aboutMenBioInfo == "" ? "还没有此项信息" : aboutMenBioInfo
        }
    }
    private var aboutMeInfoList: [ProfileAboutMe] = [] {
        didSet {
            self.detailSectionView?.aboutMeView?.detailCollectionView?.reloadData()
        }
    }
    private var interest: [String] = [] {
        didSet {
            self.detailSectionView?.interestView?.flowCollectionView?.reloadData()
        }
    }

    private var headerSectionView: YRBannerView?
    private var detailSectionView: YRHomeDetailView?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }
    private func setUpViews() {
        
        view.backgroundColor = .whiteColor()
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
        
        headerSectionView.leftFuncBtn.setImage(UIImage(named: "fs_like"), forState: .Normal)
        headerSectionView.leftFuncBtn.setImage(UIImage(named: "fs_liked"), forState: .Highlighted)
        headerSectionView.leftFuncBtn.addTarget(self, action: #selector(addLikeAction(_:)),
                                                forControlEvents: .TouchUpInside)
        headerSectionView.rightFuncBtn.setImage(UIImage(named: "fs_dialogue"), forState: .Normal)
        headerSectionView.rightFuncBtn.setImage(UIImage(named: "fs_dialogue"), forState: .Highlighted)
        headerSectionView.rightFuncBtn.setImage(UIImage(named: "fs_dialogue_slc"), forState: .Selected)
        headerSectionView.rightFuncBtn.addTarget(self, action: #selector(chatAction(_:)), forControlEvents: .TouchUpInside)
        
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
        
        detailSection.blackListBtn.addTarget(self, action: #selector(addBlackListBtnClicked), forControlEvents: .TouchUpInside)
        detailSection.claimsBtn.addTarget(self, action: #selector(claimsBtnClicked), forControlEvents: .TouchUpInside)
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
        let metrics = [ "detailTotalHeight" : "\(630 + (9 * 30))"]
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        scollBackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: metrics, views: viewsDict))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Action
    func addLikeAction(sender: UIButton) {
        print(#function)

        let param: [String: String] = [
            "uuid" : self.uuid
        ]
        YRService.addLike(userId: param, success: { [weak self] result in
            let alertView: UIAlertView = UIAlertView(title: "已将此用户加为最爱", message: "\(self?.profile?.nickname!) 会注意到的，对方上线时你也会获得通知", delegate: nil, cancelButtonTitle: "好的")
            alertView.show()
            }, fail: { error in
                print("add like error: \(error)")
        })
    }
    
    func chatAction(sender: UIButton) {
        print("add to chat list, then go to converstaion")
        openConversation(userInfo: self.profile!)
    }
    
    // MARK: 打开或者创建对话, 最完整的逻辑
    // open conversation
    // 1   if local have, then open
    // 2 else   if query excist , then open
    // 3      else creat new and save ,then open
    private func openConversation(userInfo profile: Profile) {

        let nickName = profile.nickname!
        let uuid =  profile.uuid!

        let vc = YRConversationViewController()
        guard let client = super.client else { return }
        let query = client.conversationQuery()
        client.delegate = vc
        
        let converResults = realm.objects(YRChatModel).filter(" uuid = '\(uuid)'")
        let model = YRChatModel()
        model.uuid = uuid
        model.name = nickName
        model.imgStr =  profile.avatar
        model.lastText = " last text message here "
        model.numStr = "0"
        model.time = " time"
        
        var infoDict = ["info": ""]
        if let urlStr = profile.avatar {
            infoDict = ["info": urlStr]
        }
        
        client.openWithCallback { (succeede, error) in
            guard error == nil else {
                let alertView: UIAlertView = UIAlertView(title: "聊天不可用！", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                return
            }
            
            guard converResults.count == 0 else {
                // 1 
                if let oldConv = converResults.last {
                    let oldCovID = oldConv.converstationID
                    query.getConversationById(oldCovID, callback: { (conversation, error) in
                        guard error == nil else { return }
                        vc.conversation = conversation
                        vc.profile = profile
                    })
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
            
            // MARK: 官方推荐的查询条件
            /* 构建查询条件
             * 注意：比较建议开发者仔细阅读以下三行代码，这三个条件同时进行查询在数据量日益增加的时候，也能保持查询的性能不受太大影响。
             */
            let clientIds = [uuid, YRUserDefaults.userUuid]
            print(clientIds)
            query.whereKey("m", sizeEqualTo: 2)
            query.whereKey("m", containsAllObjectsInArray: clientIds)
            query.findConversationsWithCallback({ (converstaions, error) in
                guard error == nil else { return }
                
                guard converstaions.count == 0 else {
                    // 2
                    if let cov = converstaions.last {
                        vc.conversation = cov as? AVIMConversation
                        vc.profile = profile
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                    return
                }

                // 3
                client.createConversationWithName("与\(nickName)聊天", clientIds: [uuid], attributes: infoDict, options: [AVIMConversationOption.Unique, AVIMConversationOption.None], callback:{[weak vc] (conversation, error) in
                    
                    guard error == nil else { return }
                    
                    // open conversation but no message
                    if conversation.lastMessageAt != nil {
                        print("conversation.lastMessageAt; \(conversation.lastMessageAt)")
                        model.time = ""
                    }else {
                        model.time = NSDate.coventeNowToDateStr()
                    }
                    model.converstationID = conversation.conversationId
                    // new conver , new add
                    self.addToRealm(model)
                    vc?.conversation = conversation
                    vc?.profile = profile
                    })
                self.navigationController?.pushViewController(vc, animated: true)
            })

        }
    }
        
    func addBlackListBtnClicked() {
        
        let param = ["uuid": self.uuid]
        YRService.addToBlackList(data: param, success: {[weak self] _ in
            let alertView: UIAlertView = UIAlertView(title: "已将此用户拉黑", message: "您可以在“我的页面－黑名单”条目中，解除拉黑操作！", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
            self?.navigationController?.popViewControllerAnimated(true)
            
            }, fail: { error in
                print(" add to blacklist error\(error)")
        })
    }
    
    func claimsBtnClicked() {
        let vc = YRClaimViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.userId = self.uuid
        navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: collectionViewDataSource
extension YRFriendOneViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == self.headerSectionView?.collectionView) {
            let vc = YRAlbumLargePhotoViewController()
            vc.photoUrls = self.imageRecent
            vc.showIndexPath = indexPath
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.detailSectionView!.resumeView!.collectionView) {
            return self.isAuthed.count;
        }else if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let backLb = collectionView.backgroundView as! UILabel
            if self.interest.isEmpty {
                backLb.text = "还没有添加兴趣"
            }
            return self.interest.count;
        }else if (collectionView == self.detailSectionView!.insigniaView!.collectionView) {
            return 5;
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            return 9;
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let backLb = collectionView.backgroundView as! UILabel
            if self.imageRecent!.isEmpty {
                backLb.text = "还没有可展示的图片"
            }
            
            return self.imageRecent!.count
        }
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.detailSectionView!.resumeView!.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AuthTagCell", forIndexPath: indexPath) as! AuthTagCell
            return cell
        }else if (collectionView ==  self.detailSectionView!.interestView!.flowCollectionView!){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlowUnitViewCell", forIndexPath: indexPath) as! FlowUnitViewCell
            cell.titleLb.text = self.interest[indexPath.item]
            return cell
            
        }else if (collectionView == self.detailSectionView!.aboutMeView!.detailCollectionView!) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UnitViewCell", forIndexPath: indexPath) as! UnitViewCell
            if self.aboutMeInfoList.count > 0 {
                let model = self.aboutMeInfoList[indexPath.item]
                cell.titleLb.text = model.name! + ":"
                cell.infoLb.text = model.content
            }
            return cell
        }else if (collectionView == self.headerSectionView?.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BannerCell", forIndexPath: indexPath) as! BannerCell
            let model = self.imageRecent![indexPath.row]
            cell.photoImgV.kf_showIndicatorWhenLoading = true
            cell.photoImgV.kf_setImageWithURL(model)
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let width = UIScreen.mainScreen().bounds.width
        let page = Int(scrollView.contentOffset.x / width)
        self.headerSectionView?.totalLb.text = "\(page + 1)" + "/" + "\(self.imageRecent!.count)"
    }
}

