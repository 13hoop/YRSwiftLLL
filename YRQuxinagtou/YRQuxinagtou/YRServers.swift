//
//  YRServers.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/29.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct YRService {

    internal enum ResourcePath: String, CustomStringConvertible {

        case requrieSMSCode = "/sms"
        case requrieCites = "/cities"
        
        // photo
        
        
        // user
        case userSessions = "/sessions"
        
        //
        
        var description: String {
            return "resourcePath"
        }
    }
    
    // API
    static func requireSMSCode(success completion: () -> Void, fail callBack: () -> Void) {
        YRNetwork.apiGetRequest(" url ", success: completion, failure: callBack)
    }
}
