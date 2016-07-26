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

    
    // 为了便于拼接，使用“/xxx/”形式
    enum ResourcePath: String, CustomStringConvertible {

        case requrieSMSCode = "/sms"
        case requrieCites = "/cities"
        
        // UpdatAvatar
        case upLoadAvatarImage = "/images?type=avatar"
        // UpdatPhoto
        case upLoadGalleryImage = "/images?type=gallery"
        case album = "/images?"
        
        // user
        case userSessions = "/sessions"
        
        // profile
        case user = "/users/"
        case update = "/users/update/"
        case addInterest = "/interests"
        case deleteInterest = "/interests/delete"
        
        var description: String {
            return rawValue
        }
    }
    
    // smsCode
    static func requireSMSCode(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
//        let urlStr = "http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/entries.json"
//        let header = ["Content-Type": "application/json"]
        
//        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }
    
    // logIn
    static func requireLogIn(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-AAAA-9819-A09D43522AAA"
        let body = ["mobile": "18701377365",
                    "password": "12345678"]

        let urlStr = baseURL + ResourcePath.userSessions.rawValue + "?udid=\(udid)"
        let header = ["Content-Type": "application/json"]
        YRNetwork.apiPostRequest(urlStr, body: body, header: header, success: completion, failure: callBack)
    }

    // Profile
    static func requiredProfile(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let userUuid = YRUserDefaults.userUuid
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        
        let urlStr = baseURL + ResourcePath.user.rawValue + userUuid + "?udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }
    
    // updateProflie
    static func updateProfile(params updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let body = updateParam
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.update.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: body, header: header, success: completion, failure: callBack)
    }
    
    // add interest
    static func addInterest(interest updateParam: String!, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let body: [String: String] = ["name" : updateParam!]
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.addInterest.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: body, header: header, success: completion, failure: callBack)
    }
    // delete interest
    static func deleteInterest(interest updateParam: String!, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let body: [String: String] = ["name" : updateParam!]
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.deleteInterest.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: body, header: header, success: completion, failure: callBack)
    }
    // upLoadImage：Avatar and Gallery
    static func updateAvatarImage(data uploadData: NSData, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Content-Disposition": "attachment; filename=\"ios.jpg\"/",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.upLoadAvatarImage.rawValue + "&udid=\(udid)"
        YRNetwork.upLoadFile(urlStr, header: header, data: uploadData, success: completion, failure: callBack)
    }
    static func upLoadGalleryImage(datas uploadDatas: [NSData], success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Content-Disposition": "attachment; filename=\"ios.jpg\"/",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.upLoadGalleryImage.rawValue + "&udid=\(udid)"
//        YRNetwork.upLoadFile(urlStr, header: header, data: uploadData, success: completion, failure: callBack)
        YRNetwork.upLoadMutipartFormData(urlStr, header: header, datas: uploadDatas, success: completion, failure: callBack)
    }
    static func requiredAlbumPhotos(page page:Int, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let userUuid = YRUserDefaults.userUuid
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.album.rawValue + "\(page)" + "&uuid=" + userUuid + "&udid=\(udid)"
        
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }

    
    
    // save token and id to UserDefaults
    static func saveTokenAndUserInfoOfLoginUser(loginUser: LoginUser) {
        
        YRUserDefaults.userUuid = loginUser.uuid
        YRUserDefaults.userAuthToken = loginUser.accessToken
        YRUserDefaults.userNickname = loginUser.nickname
        YRUserDefaults.userAvatarURLStr = loginUser.avatarURLString
        
        print("- save userDefault here - /n \(YRUserDefaults.userUuid)")
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

