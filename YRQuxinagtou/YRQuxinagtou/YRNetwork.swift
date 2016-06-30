//
//  YRNetwork.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/28.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Alamofire

#if DEBUG
    private let baseURL = NSURL(string: "https://api.quxiangtou.com/v1")!
#else
    private let baseURL = NSURL(string: "https://apple.com/cn")!
#endif

class YRNetwork {
    
    class func apiGetRequest(urlStr: String,success completion: () -> Void, failure callBack: () -> Void) {
        Alamofire.request(<#T##method: Method##Method#>, <#T##URLString: URLStringConvertible##URLStringConvertible#>, parameters: <#T##[String : AnyObject]?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##[String : String]?#>)
        print(#function)
        callBack()
        completion()
    }

    class func apiPostRequest(urlStr: YRService.ResourcePath, parameters: [String : AnyObject]? , failure: () -> Void, completion: () -> Void) {
        print(#function)
    }

}