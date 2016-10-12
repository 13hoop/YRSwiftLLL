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
private let userAvatarURLStr = "userAvatarURL"

private let mobileKey = "mobile"
private let captchaKey = "captcha"
private let genderKey = "gender"
private let purposeKey = "purpose"
private let want_genderKey = "want_gender"
private let age_minKey = "age_min"
private let age_maxKey = "age_max"
private let birthdayKey = "birthday"


final public class YRUserDefaults {
    
    static let defaults = NSUserDefaults(suiteName: YRConfig.appGronpId)!
    
    public static var isLogined: Bool {
        if let _ = YRUserDefaults.defaults.stringForKey(authTokenKey) {
            return true
        } else {
            return false
        }
    }
    
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
            defaults.setObject(newValue, forKey: userAvatarURLStr)
        }
    }

    static var mobile: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: mobileKey)
        }
    }
    static var captcha: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: captchaKey)
        }
    }
    static var gender: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: genderKey)
        }
    }
    static var purpose: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: purposeKey)
        }
    }
    static var want_gender: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: want_genderKey)
        }
    }
    static var age_min: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: age_minKey)
        }
    }
    static var age_max: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: age_maxKey)
        }
    }
    static var birthday: String = "" {
        willSet {
            defaults.setObject(newValue, forKey: birthdayKey)
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
        return "-------->>>> LoginUserInfo begin >>>> \n(uuid: \(uuid) accessToken: \(accessToken), nickname: \(nickname)\n<<<< LoginUserInfo end <<<<-------"
    }
}

// register models
public struct RegisterUser {
    
    public let mobile: String
    public let captcha: String
    public let gender: String
    public let purpose: String
    public let want_gender: String
    public let age_min: String
    public let age_max: String
    public let birthday: String
}
