//
//  YRPhotoAlert.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/17.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import Photos

enum YRPicherType {
    case SingleSelection
    case MultiSelect
}

struct YRPickerMaxSelectNum {
    static var maxSeleted: Int?
}

private struct YRSignalImagePicker {
    static let sigalPicker: UIImagePickerController = {
        $0.allowsEditing = true
        return $0
    }(UIImagePickerController())
}

//private typealias yr_mutiPickerCallBack = (images: [UIImage], imageAssets: [PHAsset]) -> Void

class YRPhotoPicker {

//    static var mutiPickerCallBack: 
    
    private lazy var imagePicker: UIImagePickerController = {
        $0.allowsEditing = true
        return $0
    }(UIImagePickerController())
    
    /**
     弹出alert“从相册选择” 或 “相机”, __单选图片__
     
     - parameter  参数T : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
     
     __Notice:__  ViewController extention 需要遵守UIImagePickerControllerDelegate, UINavigationControllerDelegate协议，并自己实现方法
     */
    internal class func photoSinglePickerFromAlert<T : UIViewController where T:UIImagePickerControllerDelegate, T: UINavigationControllerDelegate> (inViewController viewController: T) {

        let vc = viewController
        let imagePicker = YRSignalImagePicker.sigalPicker
        imagePicker.delegate = vc
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default) { action in
            
            let cameraRollAction: YRProposerAction = { [weak vc] in
                guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
                    else {
                        vc?.cannotAlowedToAcessCameraRoll()
                        return
                }
                
                if let strongSelf = vc {
                    
                    imagePicker.sourceType = .PhotoLibrary
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            
            yr_proposeToAuth(.Camera, agreed: cameraRollAction, rejected: {
                vc.cannotAlowedToAcessCamera()
            })
        }
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "相机", style: .Default) { action in
            let openCamera: YRProposerAction = { [weak vc] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.Camera)
                    else {
                        vc?.cannotAlowedToAcessCamera()
                        return
                }
                
                if let strongSelf = vc {
                    imagePicker.sourceType = .Camera
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            
            }
            
            yr_proposeToAuth(.Camera, agreed: openCamera, rejected: {
                vc.cannotAlowedToAcessCamera()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
    
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     弹出alert“从相册选择” 或 “相机”, __多选图片__
     
     - parameter  参数T : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
     - parameter  limited: Int 设置一次最多选取的图片数
     
     __Notice:__  ViewController extention 需要遵守UIImagePickerControllerDelegate, UINavigationControllerDelegate协议，并自己实现方法
     */
    internal class func photoMultiPickerFromAlert<T : UIViewController where T:UIImagePickerControllerDelegate, T: UINavigationControllerDelegate> (inViewController viewController: T, limited maxNum: Int) {

        let vc = viewController as! YRProfileTableViewController
        let imagePicker = YRSignalImagePicker.sigalPicker
        imagePicker.delegate = vc
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default) { action in
            
            yr_proposeToAuth(.Photos, agreed: {
                
                let imagePicker: YRPhotoPickerViewController = YRPhotoPickerViewController()
                imagePicker.maxSelectedNum = maxNum
                imagePicker.completion = {[weak vc] imageSets in
                    
                    // --- call back here ---
                    vc?.updatePhoto()
                }
                vc.navigationController?.pushViewController(imagePicker, animated: true)
                
                }, rejected: { 
                vc.cannotAlowedToAcessCameraRoll()
            })
            
        }
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "相机", style: .Default) { action in
            let openCamera: YRProposerAction = { [weak vc] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.Camera)
                    else {
                        vc?.cannotAlowedToAcessCamera()
                        return
                }
                
                if let strongSelf = vc {
                    imagePicker.sourceType = .Camera
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
            }
            
            yr_proposeToAuth(.Camera, agreed: openCamera, rejected: {
                vc.cannotAlowedToAcessCamera()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
}


