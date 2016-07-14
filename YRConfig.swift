//
//  YRConfig.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/16.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRConfig: AVObject {
    
    // color
    static let plainBackground = "#F3F6F9"
    static let mainTextColor = "#656565"
    static let themeTintColor = "#60AFFF"

    // groupId
    static let appGronpId = "Group-YRQxt.Inc"
    
    // leanCloud
    private struct LeanCloud {
        static let appId = "dm3umf7CG2umcAwzepQ5HXwB"
        static let appKey = "k9bVOrFqAw3VSn7iVhCwPKDd"
        static let masterKey = "BkYd02aLTqyEeqe7MC0GufW7"
    }
    
    class func leanCloud() {
        AVOSCloud.setApplicationId(LeanCloud.appId, clientKey: LeanCloud.appKey)
        
        #if DEBUG
        AVOSCloud.setAllLogsEnabled(true)
        #endif
    }
}

