//
//  YRApplyForAuthorization.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/16.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

/*
    处理隐私资源申请授权
*/

public enum YRPrivateResource {
    case Photos
    case Camera
    case Microphone
    case Contacts
    
//    public var isNotDeterminedAuthorization: Bool {
//        switch self {
//        case .Photos:
//            return PHPhotoLib
//        default:
//            <#code#>
//        }
//    }
}

public typealias YRProposerAction = () -> Void

// 申请权限
public func yr_proposeToAuth(resourse: YRPrivateResource, agreed allowedToAccess: YRProposerAction, rejected failureAction: YRProposerAction) {
    switch resourse {
    case .Photos:
        proposeToAccessPhotos(agreed: allowedToAccess, rejected: failureAction)
    case .Camera:
        proposeToAccessCamera(agreed: allowedToAccess, rejected: failureAction)
    default:
        return
    }
}

private func proposeToAccessPhotos(agreed successAction: YRProposerAction, rejected failtureAction: YRProposerAction) {
    PHPhotoLibrary.requestAuthorization { (status) in
        dispatch_async(dispatch_get_main_queue(), {
            switch status {
            case .Authorized:
                successAction()
            default:
                failtureAction()
            }
        })
    }
}
private func proposeToAccessCamera(agreed successAction: YRProposerAction, rejected failtureAction: YRProposerAction) {
    AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) in
        dispatch_async(dispatch_get_main_queue(), { 
            granted ? successAction() : failtureAction()
        })
    }
}
