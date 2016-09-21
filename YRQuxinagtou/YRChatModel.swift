//
//  YRChatModel.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/9/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import RealmSwift

class YRChatModel: Object {
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    dynamic var uuid: String?
    dynamic var converstationID: String = "0"
    dynamic var lastText: String?
    dynamic var imgStr: String?
    dynamic var name: String?
    dynamic var time: String?
    dynamic var numStr: String = "0"


}
