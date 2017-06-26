//
//  YRConfig.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/16.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloud
import AVOSCloudIM

class YRConfig: AVObject {
    
    // color
    static let plainBackground = "#F3F6F9"
    static let plainBackgroundColored = UIColor.hexStringColor(hex: plainBackground)
    
    static let disabledColored = UIColor(red: 209/255.0, green: 214/255.0, blue: 218/255.0, alpha: 0.9)
    
    static let separateLineColored = UIColor.hexStringColor(hex: "#DFDFDF")
    
    static let mainTextColor = "#656565"
    static let mainTextColored = UIColor.hexStringColor(hex: "#656565")
    static let mainTitleTextColor = "#282828"
    static let mainTitleTextColored = UIColor.hexStringColor(hex: mainTitleTextColor)

    static let themeTintColor = "#60AFFF"
    static let themeTintColored = UIColor.hexStringColor(hex: "#60AFFF")
    static let authTagColor = "#DBB76B"
    static let authTagColored = UIColor.hexStringColor(hex: "#DBB76B")
    
    static let systemTintColored = UIColor(red: 0.0, green: 122/255.0, blue: 1.0, alpha: 1.0)


    // groupId
    static let appGronpId = "Group-YLLLRLLLQxtLLL.Inc"
    
    // leanCloud
    private struct LeanCloud {
        static let appId = "LLLdm3umf7CLLLG2umcAwzepQ5HXwB"
        static let appKey = "LLLk9bVOrFLLLqAw3VSn7iVhCwPKDd"
        static let masterKey = "LLLBkYdLLL02aLTqyEeqe7MC0GufW7"
    }
    
    class func leanCloud() {
        AVOSCloud.setApplicationId(LeanCloud.appId, clientKey: LeanCloud.appKey)
        AVOSCloud.setAllLogsEnabled(true)
        AVIMClient.setUserOptions([AVIMUserOptionUseUnread: true])
    }
    
    override init() {
        super.init()        
    }
}

