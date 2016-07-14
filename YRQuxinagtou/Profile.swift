//
//  Profile.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/12.
//  Copyright © 2016年 YongRen. All rights reserved.
//
import UIKit

struct Profile {
    
    var uuid: String?
    var nickname: String?
    var age: String?
    var gender_name: String?
    var zodiac_sign: String? /// 星座
    var province: String?
    var city: String?
    var avatar: String?
    
    var house_certificate: Bool?
    var car_certificate: Bool?
    var real_name_certificate: Bool?
    var balance: Bool?
    var consume: Bool?

    var attraction: Int?
    var paired_count: Int?
    
    var badges: [AnyObject]?
    var recent_images: [AnyObject]?
    var about_me: [AnyObject]?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        print(">>> >>> >>> in <<< <<< <<<")
        if  let uuid = info["uuid"] as? String,
            let attraction = info["attraction"] as? Int,
            let paired_count = info["paired_count"] as? Int,
            let age = info["age"] as? String,
            let nickname = info["nickname"] as? String,
//            let birthplace = info["birthplace"] as? String?,
//            let nation = info["nation"] as? String?,
//            let height = info["height"] as? String?,
            let province = info["province"] as? String {
            print("_________ iiiiii _________")
            self.uuid = uuid
            self.attraction = attraction
            self.paired_count = paired_count
            self.age = age
            self.nickname = nickname
//            self.birthplace = birthplace
//            self.nation = nation
//            self.height = height
            self.province = province
            
//            if let badges = info["badges"] as? [AnyObject],
//                let recent_images = info["recent_images"] as? [AnyObject] {
//                self.badges = badges
//                self.recent_images = recent_images
//            }
        }
    }
}