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
    
    var bio: String? /// 自我介绍
    
//    var relationship: Int? /// 婚恋关系
//    var industry: Int? /// 职业
//    var kids: Int? /// 子女
//    var smoking: Int? /// 吸烟
//    var drinking: Int? /// 饮酒
//    var exercise: Int? /// 运动
    
    var info_integrity: Int? /// 资料完整度
    
    var house_certificate: Bool?
    var photo_certificate: Bool?
    var real_name_certificate: Bool?
    var degree_certificate: Bool?
    var car_certificate: Bool?
    var isAuthedArray: [Bool] = [false, false, false, false, false]
    
//    var interests: [AnyObject?]
    
    var balance: String? /// 钻石余额
    var consume: String? /// 钻石已消费数
    var attraction: Int? /// 颜值

    //    var paired_count: Int? /// 与之配对的人数
    
//    var badges: [AnyObject]? /// 徽章
//    var recent_images: [AnyObject]?
    var about_me: [ProfileAboutMe] = [ProfileAboutMe]()
    
//    encounter_prefs_summary /// 速配筛选条件总结
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        print(">>> >>> >>> in <<< <<< <<<")
//        let attraction = info["attraction"] as? Int,
//        let paired_count = info["paired_count"] as? Int,
//        self.attraction = attraction
//        self.paired_count = paired_count
        
        if  let uuid = info["uuid"] as? String,
            let nickname = info["nickname"] as? String,
            let age = info["age"] as? String,
            let gender_name = info["gender_name"] as? String?,
            let zodiac_sign = info["zodiac_sign"] as? String?,
            let province = info["province"] as? String,
            let city = info["city"] as? String?,
            let avatar = info["avatar"] as? String?,
            let bio = info["bio"] as? String?,
            let balance = info["balance"] as? String?,
            let consume = info["consume"] as? String?,
            let attraction = info["attraction"] as? Int?
        {
            print("_________ in1 _________")
            self.uuid = uuid
            self.nickname = nickname
            self.age = age
            self.gender_name = gender_name
            self.zodiac_sign = zodiac_sign
            self.province = province
            self.city = city
            self.avatar = avatar
            self.bio = bio
            self.balance = balance
            self.consume = consume
            self.attraction = attraction
        }
        
        if  let house_certificate = info["house_certificate"] as? String?,
            let car_certificate = info["car_certificate"] as? String?,
            let real_name_certificate = info["real_name_certificate"] as? String?,
            let degree_certificate = info["degree_certificate"] as? String?,
            let photo_certificate = info["photo_certificate"] as? String?
        {
            
            print("_________ in2 _________")

            self.house_certificate = house_certificate != "0"
            self.car_certificate = car_certificate != "0"
            self.real_name_certificate = real_name_certificate != "0"
            self.photo_certificate = photo_certificate != "0"
            self.degree_certificate = degree_certificate != "0"
            
            isAuthedArray = [self.photo_certificate!, self.degree_certificate!,  self.house_certificate!, self.car_certificate!, self.real_name_certificate!]
        }
        
        if  let about_me = info["about_me"] as? [AnyObject]? {
            print("_________ in3 _________")
            for obj in about_me! {
                let about = ProfileAboutMe(fromArray: obj as! [String: AnyObject])
                self.about_me.append(about)
            }
        }
    }
}

struct ProfileAboutMe {
    var name: String?
    var content: String?
    
    init(fromArray info: [String: AnyObject]) {
        if  let name = info["name"] as? String,let content = info["content"] as? String {
            self.name = name
            self.content = content
        }
    }
}