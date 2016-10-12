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

        Alamofire.request(.POST, urlStr, parameters: parameters, encoding: .JSON, headers: heaserDict).validate().responseJSON {
            response in
                response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
        }
    }

    // Multipart/FormData type ==> image
    class func upLoadMutipartFormData(urlStr: String,header heaserDict: [String: String]?, image uploadImage: UIImage, prama pramaDict: [String: String], success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        
        Alamofire.upload(.POST, urlStr, headers: heaserDict, multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(uploadImage, 1) {
                multipartFormData.appendBodyPart(data: imageData, name: "image", fileName: "iosImage.jpg", mimeType: "image/png")
            }
            for (key, value) in pramaDict {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
        }, encodingCompletion: { encodingResult in
            
            switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { respose in
                        switch respose.result {
                        case .Success:
                            print(" -- success  :\(respose.result.debugDescription )")
                            completion(nil)
                        case .Failure:
                            print(" -- failure  :\(respose.result.debugDescription )")
                            callBack(nil)
                        }
                    })
                case .Failure(let encodingRrror):
                    callBack(nil)
                    print(" encoding error:\(encodingRrror)")
                }
        })
    }

    // upload
    class func upLoadFile(urlStr: String,header heaserDict: [String: String]?,data uploadData: NSData, success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        
        Alamofire.upload(.POST, urlStr, headers: heaserDict, data: uploadData)
            .progress({ (bytes, totalbytes, totalbytesExpert) in
                print("\(bytes)/\(totalbytes) and expert \(totalbytesExpert)")
            })
            .responseJSON {
                response in
                response.result.isSuccess ? completion(response.result.value) : callBack(response.result.error)
        }
    }
    
    class func upLoadFiles(urlStr: String,header heaserDict: [String: String]?,datas uploadData: [NSData], success completion: (AnyObject?) -> Void, failure callBack: (NSError?) -> Void) {
        
        var results:[AnyObject] = []
        let group: dispatch_group_t = dispatch_group_create()
        
        for (index, obj) in uploadData.enumerate() {
            dispatch_group_enter(group)
            Alamofire.upload(.POST, urlStr, headers: heaserDict, data: obj)
                .progress({ (bytes, totalbytes, totalbytesExpert) in
                    print("\(bytes)/\(totalbytes) and expert \(totalbytesExpert)")
                })
                .responseJSON {
                    response in
                    if response.result.isSuccess {
                        print(" 第\(index)张完成 \(response.result.value)")
                        let lockQueue = dispatch_queue_create("YongRen.LockQueue", nil)
                        dispatch_sync(lockQueue) {
                            results.append(response.result.value!)
                        }
                        dispatch_group_leave(group)
                    }else {
                        callBack(response.result.error)
                        print(" index \(index)失败 error\(response.result.error)")
                        dispatch_group_leave(group)
                    }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            completion(" all success ")
        }
    }
}


/**************************************************************
 |                 batch request to server                     |
 **************************************************************/
final class YRBatchOperation: NSOperation {
    
    enum State: String{
        case Ready, Executing, Finised
        
        private  var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    override var executing: Bool {
        return state == .Executing
    }
    override var finished: Bool {
        return  state == .Finised
    }
    override var asynchronous: Bool {
        return true
    }
    override func start() {
        if cancelled {
            state = .Finised
            return
        }
        
        main()
        state = .Executing
    }
    override func cancel() {
        state = .Finised
    }
    
    override func main() {
    
    }
    
    
}

