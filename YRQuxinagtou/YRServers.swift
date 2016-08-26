//
//  YRServers.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/29.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import AVFoundation

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
        case album = "/images"
        
        // user
        case userSessions = "/sessions"
        // visitor
        case visitor = "/users/visitor/?page=1"
        
        // friends
        case friends = "/users/find"
        // filters
        case filters = "/filters"
        
        // meet
        case meetFriends = "/users/meet"
        // like
        case like = "/favorites"
        // disLike
        case disLike = "/favorites/delete"
        // claim
        case claim = "/users/report"
        // black list
        case blackList = "/blacklist"
        // 
        case blackListDelete = "/blacklist/delete"
        
        // profile
        case user = "/users/"
        case update = "/users/update/"
        case addInterest = "/interests"
        case deleteInterest = "/interests/delete"
        case address = "/address_book/region"
        
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
    static func requireLogIn(user info: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-AAAA-9819-A09D43522AAA"
        let urlStr = baseURL + ResourcePath.userSessions.rawValue + "?udid=\(udid)"
        let header = ["Content-Type": "application/json"]
        YRNetwork.apiPostRequest(urlStr, body: info, header: header, success: completion, failure: callBack)
    }

    // meet
    static func requiredMeet(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.meetFriends.rawValue + "?udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }
    
    // visitor
    static func requiredVisitor(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let userUuid = YRUserDefaults.userUuid
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.visitor.rawValue + userUuid + "?udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }
    
    // Friends 
    static func requiredFriends(page page:Int, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.friends.rawValue + "?page=\(page)" + "&udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }

    // filters
    static func requiredFilters(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.filters.rawValue + "?type=meet&udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }
    static func updateFilters(data updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.filters.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: updateParam, header: header, success: completion, failure: callBack)
    }

    
    // like
    static func addLike(userId updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.like.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: updateParam, header: header, success: completion, failure: callBack)
    }
    // disLike
    static func deleteLike(userId updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.disLike.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: updateParam, header: header, success: completion, failure: callBack)
    }
    // claim
    static func claimUser(data updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.claim.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: updateParam, header: header, success: completion, failure: callBack)
    }
    // add to black list
    static func addToBlackList(data updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.blackList.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: updateParam, header: header, success: completion, failure: callBack)
    }
    // delete from black list
    static func deleteFromBlackList(data updateParam: [String: AnyObject]?, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.blackListDelete.rawValue + "?udid=\(udid)"
        YRNetwork.apiPostRequest(urlStr, body: updateParam, header: header, success: completion, failure: callBack)
    }
    // get black list
    static func requiredBlacklist(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.blackList.rawValue + "?udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
    }

    // getProfile
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
    
    // address
    static func requiredAddressData(success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.address.rawValue + "?udid=\(udid)"
        YRNetwork.apiGetRequest(urlStr, header: header, success: completion, failure: callBack)
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
        
        let yrQueue = NSOperationQueue()
        
        ///// .... /////////
        for uploadData in uploadDatas {
            let op = NSBlockOperation(block: {
                YRNetwork.upLoadFile(urlStr, header: header, data: uploadData, success: completion, failure: callBack)
            })
        }
    
    }
    
    static func requiredAlbumPhotos(page page:Int, success completion: (AnyObject?) -> Void, fail callBack: (NSError?) -> Void) {
        
        let udid = "6FC97065-EFC4-43EF-9819-A09D43522F7C"
        let userUuid = YRUserDefaults.userUuid
        let authToken = "Qxt " + YRUserDefaults.userAuthToken
        let header = ["Content-Type": "application/json",
                      "Authorization": authToken]
        let urlStr = baseURL + ResourcePath.album.rawValue + "?page=\(page)" + "&uuid=" + userUuid + "&udid=\(udid)"
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

/**************************************************************
|                         audio server                        |
**************************************************************/
final class YRAudioService: NSObject {
    
    static let sharedManager = YRAudioService()

    //
    var checkRecordTimeoutTimer: NSTimer?

    var shouldStart: Bool = false
    
    var audioFileURL: NSURL?
    var audioRecorder: AVAudioRecorder?
    
    let queue = dispatch_queue_create("YRAudioService", DISPATCH_QUEUE_SERIAL)

    func yr_beginRecordWithFileURL(fileURL: NSURL, audioDelegate: AVAudioRecorderDelegate) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch let error {
            print("beginRecordWithFileURL set category failed: \(error)")
        }
    
        print(#function)

        do {
            
            yr_proposeToAuth(.Microphone, agreed: {
                
                print(" - accessed - ")
                
                AVAudioSession.sharedInstance().requestRecordPermission({ allowed in
                    print(" \(allowed) ")
                })
//                
//                let session = AVAudioSession.sharedInstance()
//                do {
//                    session.setCategory(<#T##category: String##String#>, withOptions: <#T##AVAudioSessionCategoryOptions#>)
//                } catch _ {}
//                
                
//                self.yr_prepareRecordWithFileURL(fileURL, audioRecordDelegate: audioDelegate)
//
//                if let audioRecorder = self.audioRecorder {
//                    if audioRecorder.recording {
//                        audioRecorder.stop()
//                    
//                        // timer end
//                        
//                    }else {
//                        if !self.shouldStart {
//                            audioRecorder.record()
//                            print(" － 0️⃣ －> audio record did start ")
//                        }
//                    }
//                }
            }, rejected: {
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
                    viewController = appDelegate.window?.rootViewController {
                        viewController.cannotAllowedToAcessMicro()
                }
            })
        }
    }
    
    func yr_prepareRecordWithFileURL(fileURL: NSURL, audioRecordDelegate: AVAudioRecorderDelegate) {
        
        audioFileURL = fileURL
        let recordConfig: [String : AnyObject] = [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey : AVAudioQuality.High.rawValue,
            AVEncoderBitRateKey : 64000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0 ]
        
        print(fileURL)
        
        do {
            let audioRecorder = try AVAudioRecorder(URL: fileURL, settings: recordConfig)
            audioRecorder.delegate = audioRecordDelegate
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            self.audioRecorder = audioRecorder
            
        } catch let error {
            self.audioRecorder = nil
            print("prepare AVAudioRecorder error: \(error)")
        }
    }
    
    func yr_endRecord() {
        
        if let audioRecorder = self.audioRecorder {
            if audioRecorder.recording {
                audioRecorder.stop()
            }
        }
        
        dispatch_async(queue) { 
            let _ = try? AVAudioSession.sharedInstance().setActive(false, withOptions: .NotifyOthersOnDeactivation)
        }
        
        // timer end
    }
    
}




