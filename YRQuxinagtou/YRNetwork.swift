//
//  YRNetwork.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/28.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Alamofire

class YRNetwork {
    
    class func apiGetRequest(urlStr: String,header heaser: [String: String]?, success completion: () -> Void, failure callBack: () -> Void) {
        
        Alamofire.request(Alamofire.Method.GET, urlStr, parameters: nil, encoding: .URL, headers: heaser).validate().responseJSON { response in
            
            print(response.result.debugDescription)
            response.result.isSuccess ? completion() : callBack()
        }
    }

    class func apiPostRequest(urlStr: String,body parameters: [String: AnyObject]?,header heaserDict: [String: String]?, success completion: () -> Void, failure callBack: (NSError?) -> Void) {

        Alamofire.request(.POST, urlStr, parameters: parameters, encoding: .JSON, headers: heaserDict).validate().responseJSON { response in
            
            response.result.isSuccess ? completion() : callBack(response.result.error)
            
        }
        
    }
}