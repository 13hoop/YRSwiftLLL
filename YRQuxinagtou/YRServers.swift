//
//  YRServers.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/29.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

#if DEBUG
    private let baseURL: String = "https://api.quxiangtou.com/v1"
#else
    private let baseURL: String = "https://api.quxiangtou.com/v1"
#endif

struct YRService {

    enum ResourcePath: String, CustomStringConvertible {

        case requrieSMSCode = "/sms"
        case requrieCites = "/cities"
        
        // photo
        
        
        // user
        case userSessions = "/sessions"
        
        var description: String {
            return rawValue
        }
    }
    
    // API
    static func requireSMSCode(success completion: () -> Void, fail callBack: () -> Void) {
        
        let urlStr = "http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json"
        let header = ["Content-Type": "application/json"]
        
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }
    
    static func requireLogIn(success completion: () -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-AAAA-9819-A09D43522AAA"
        let urlStr = baseURL + ResourcePath.userSessions.rawValue + "?udid=\(udid)"
        let body = ["mobile": "18701377365",
                    "password": "12345678"]
        let header = ["Content-Type": "application/json"]
        
        print(urlStr)
        YRNetwork.apiPostRequest(urlStr, body: body, header: header, success: completion, failure: callBack)
    }
}
