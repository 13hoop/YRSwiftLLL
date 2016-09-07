//
//  YRUserDefaults.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/12.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

private let uuidKey = "uuid"
private let nicknameKey = "nickname"
private let authTokenKey = "auth_token"
//private let uuidKey = "nickname"
//private let uuidKey = "nickname"
//private let uuidKey = "nickname"


final public class YRUserDefaults {
    
    static let defaults = NSUserDefaults(suiteName: YRConfig.appGronpId)!
    
    
//    public static var isLogined: Bool {
//        
//        if let _ = YRUserDefaults.defaults.stringForKey(authTokenKey).value {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    public static var authToken = {
//        let authToken = defaults.stringForKey(authTokenKey)
//        return defaults.setObject(authToken, forKey: authTokenKey)
//        }
//    }()
    
    static var userUuid: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: uuidKey)
        }
    }
    static var userNickname: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: nicknameKey)
        }
    }
    static var userAuthToken: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: authTokenKey)
        }
    }
    static var userAvatarURLStr: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: authTokenKey)
        }
    }
}

// loginUser Models
public struct LoginUser: CustomStringConvertible {
    
    public let accessToken: String
    public let nickname: String
    public let uuid: String
    public let avatarURLString: String
    
    public var description: String {
        return "-------->>>> LoginUserInfo begin >>>> \n(uuid; \(uuid) accessToken: \(accessToken), nickname: \(nickname)\n<<<< LoginUserInfo end <<<<-------"
    }
}