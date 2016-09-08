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
    var info_integrity: String? /// 资料完整度

    var bio: String? /// 自我介绍
    var relationship: String? /// 婚恋关系
    var birthplace: String? /// 出生地
    var nation: String? /// 民族
    var height: String? /// 身高
    var body_type: String? /// 体型
    var industry: String? /// 职业
    var annual_income: String? /// 年收入
    var living: String? /// 居住
    var kids: String? /// 子女
    var smoking: String? /// 吸烟
    var drinking: String? /// 饮酒
    var exercise: String? /// 运动
    var editPageArr = [String?]() /// -- 组合 --
    
//    1 - 已认证
//    0 - 未认证
//    2 - 审核中
    var house_certificate: String?
    var photo_certificate: String?
    var real_name_certificate: String?
    var degree_certificate: String?
    var car_certificate: String?
    var isAuthedArray = [String?]() /// -- 组合 --
    
    var interests = [String]()
    
    var balance: String? /// 钻石余额
    var consume: String? /// 钻石已消费数
    var attraction: String? /// 颜值

    var recent_images = [NSURL]()
//    var paired_count: Int? /// 与之配对的人数
//    var badges: [AnyObject]? /// 徽章
    var encounter_prefs_summary: String? /// 速配筛选条件总结

    var about_me: [ProfileAboutMe] = [ProfileAboutMe]()
    
    init(fromJSONDictionary info: [String: AnyObject]) {
            
        if  let uuid = info["uuid"] as? String,
            let nickname = info["nickname"] as? String,
            let age = info["age"] as? String,
            let gender_name = info["gender_name"] as? String?,
            let zodiac_sign = info["zodiac_sign"] as? String?,
            let province = info["province"] as? String,
            let city = info["city"] as? String?,
            let avatar = info["avatar"] as? String?,
            
            let balance = info["balance"] as? String?,
            let consume = info["consume"] as? String?,
            
            let bio = info["bio"] as? String?,
            let relationship = info["relationship"] as? String?,
            let birthplace = info["birthplace"] as? String?,
            let nation = info["nation"] as? String?,
            let height = info["height"] as? String?,
            let body_type = info["body_type"] as? String?,
            let industry = info["industry"] as? String?,
            let annual_income = info["annual_income"] as? String?,
            let living = info["living"] as? String?,
            let kids = info["kids"] as? String?,
            let smoking = info["smoking"] as? String?,
            let drinking = info["drinking"] as? String?,
            let exercise = info["exercise"] as? String?
        {
//            print("_________ in1 _________")
            self.uuid = uuid
            self.nickname = nickname
            self.age = age
            self.gender_name = gender_name
            self.zodiac_sign = zodiac_sign
            self.province = province
            self.city = city
            self.avatar = avatar
            
            self.balance = balance
            self.consume = consume
            
            self.bio = bio
            self.relationship = relationship
            self.birthplace = birthplace
            self.nation = nation
            self.height = height
            self.body_type = body_type
            self.industry = industry
            self.annual_income = annual_income
            self.living = living
            self.kids = kids
            self.smoking = smoking
            self.drinking = drinking
            self.exercise = exercise
            self.editPageArr = [relationship, height, body_type, industry, annual_income, living, kids, smoking, drinking, exercise]
        }
        
        if  let house_certificate = info["house_certificate"] as? String?,
            let car_certificate = info["car_certificate"] as? String?,
            let real_name_certificate = info["real_name_certificate"] as? String?,
            let degree_certificate = info["degree_certificate"] as? String?,
            let photo_certificate = info["photo_certificate"] as? String?
        {
            
//            print("_________ in2 _________")

            self.house_certificate = house_certificate
            self.car_certificate = car_certificate
            self.real_name_certificate = real_name_certificate
            self.photo_certificate = photo_certificate
            self.degree_certificate = degree_certificate
            
            isAuthedArray = [self.photo_certificate, self.degree_certificate,  self.house_certificate, self.car_certificate, self.real_name_certificate]
        }
        
        if  let about_me_Op = info["about_me"] as? [AnyObject]? {
//            print("_________ in3 _________")

            if let about_me = about_me_Op {
                for obj in about_me {
                    let about = ProfileAboutMe(fromArray: obj as! [String: AnyObject])
                    self.about_me.append(about)
                }
            }
        }
            
        if let interests = info["interests"] as? [String] {
            self.interests = interests
        }
        
        if let recent_images = info["recent_images"] as? [String] {
            self.recent_images = recent_images.map({ (str: String) -> NSURL in
                return NSURL(string: str)!
            })
        }
        
        if let encounter_prefs_summary = info["encounter_prefs_summary"] as? String? {
            self.encounter_prefs_summary = encounter_prefs_summary
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