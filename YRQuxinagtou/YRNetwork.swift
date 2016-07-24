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
        
//                let qq = Alamofire.request(.POST, urlStr, parameters: parameters, encoding: .JSON, headers: heaserDict).responseJSON { response in
//                    
//                    print(response.debugDescription)
//                    response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
//                }
//                print(qq.debugDescription)
//
        Alamofire.request(.POST, urlStr, parameters: parameters, encoding: .JSON, headers: heaserDict).validate().responseJSON {
            response in
                response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
        }
    }
    
    class func upLoadFile(urlStr: String,header heaserDict: [String: String]?,data uploadData: NSData, success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        Alamofire.upload(.POST, urlStr, headers: heaserDict, data: uploadData).responseJSON {
            response in
                response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
        }
    }

    class func upLoadMutipartFormData(urlStr: String,header heaserDict: [String: String]?,datas uploadDatas: [NSData], success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        
        Alamofire.upload(.POST, urlStr, headers: heaserDict, multipartFormData: { mutipartFornData in
            
            // －－ mutipart data here －－
            for data in uploadDatas {
                mutipartFornData.appendBodyPart(data: data, name: "ios.jpg")
            }
            
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { respose in
                        switch respose.result {
                        case .Success:
                            print(" success  :\(respose.result.value )")
                        case .Failure:
                            print(" failure  :\(respose.result.value )")
                        }
                    })
                case .Failure(let encodingRrror):
                    print(encodingRrror)
                }
            }
        )
        
    }

}