//
//  EditerMe.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/19.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

struct YREidtMe {
    let titleListArr: [String] = ["个人介绍", "出生地", "民族", "婚恋状态", "身高", "体型", "职业", "年收入", "居住情况", "子女情侣", "吸烟", "饮酒", "运动"]
    let titleKeys:[String] = ["relationship", "height", "body_type", "industry", "annual_income", "living", "kids", "smoking", "drinking", "exercise"]
    let metaArr: [String: AnyObject] = [
        "relationship": ["用户未选择", "未婚无伴侣", "未婚有伴侣", "已婚", "离异", "丧偶"],
        "nation": ["用户未选择", "用户未选择", "用户未选择", "用户未选择",],
        "birthplace": ["01", "02", "03", "04", "05"],
        "height": ["用户未选择", "用户未选择", "用户未选择", "用户未选择",],
        "industry": ["用户未选择", "互联网/游戏/软件", "电子/通信/硬件", "房地产/建筑/物业", "金融", "消费品", "汽车/机械/制造", "服务/外包/中介", "广告/传媒/教育/文化", "交通/贸易/物流", "制药/医疗", "能源/化工/环", "政府/农林牧渔"],
        "body_type": ["用户未选择", "丰满 (仅女性)", "高挑 (仅女性)", "肌肉男 (仅男性)", "强壮 (仅男性)", "匀称", "穿衣显瘦脱衣有肉", "偏瘦", "柔软的胖子"],
        "annual_income": ["用户未选择", "5万以下", "5~10万", "10~20万", "20~50万", "50~100万", "100万以上"],
        "living": ["用户未选择", "一个人住", "和伴侣住", "住在宿舍", "合租", "和父母住"],
        "kids": ["用户未选择", "没有，将来也不想要", "将来会有", "已有孩子", "孩子已独立"],
        "smoking": ["用户未选择", "从不", "偶尔", "看应酬需要", "每天"],
        "drinking": ["用户未选择", "从不", "偶尔", "看应酬需要", "喜欢"],
        "exercise": ["用户未选择", "从不运动", "偶尔运动", "规律性运动", "每天都运动"]
    ]
//    
//    func trans(numStr str: String) -> NSIndexPath {
//        
//    }
//    
//    
//    // "0"  ~>  "用户未选择"
//    func trans(numStr str: String) -> String {
//        
//    }
//    
//    //  indexPath.row = 0  ~>  "0"
//    func trans(rowIndex str: NSIndexPath) -> String {
//        
//    }
//    
    
}
