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
    
    class func apiGetRequest(urlStr: String,header heaser: [String: String]?, success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        
//        let qq = Alamofire.request(Alamofire.Method.GET, urlStr, parameters: nil, encoding: .URL, headers: heaser).responseJSON { response in
//            response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
//        }
//        print(qq.debugDescription)

        Alamofire.request(Alamofire.Method.GET, urlStr, parameters: nil, encoding: .URL, headers: heaser).validate().responseJSON { response in
            response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
        }
    }

    class func apiPostRequest(urlStr: String,body parameters: [String: AnyObject]?,header heaserDict: [String: String]?, success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        
                let qq = Alamofire.request(.POST, urlStr, parameters: parameters, encoding: .JSON, headers: heaserDict).responseJSON { response in
                    
                    print(response.debugDescription)
                    response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
                }
//                print(qq.debugDescription)
//
//        Alamofire.request(.POST, urlStr, parameters: parameters, encoding: .JSON, headers: heaserDict).validate().responseJSON { response in
//            response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
//        }
    }
}