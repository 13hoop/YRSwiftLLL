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


class YRPhotoPicker {
    private lazy var imagePicker: UIImagePickerController = {
        $0.allowsEditing = true
        return $0
    }(UIImagePickerController())
    var finalPhotos = [UIImage]()
    
    /**
     弹出alert“相机”, __拍摄__
     - parameter 参数T : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
     
     __Notice:__  ViewController extention 需要遵守UIImagePickerControllerDelegate, UINavigationControllerDelegate协议，并自己实现方法
     */
    internal class func takePhotoAlert<T : UIViewController where T:UIImagePickerControllerDelegate, T: UINavigationControllerDelegate> (inViewController viewController: T) {
        
        let vc = viewController
        let imagePicker = YRSignalImagePicker.sigalPicker
        imagePicker.delegate = vc
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "相机", style: .Default) { action in
            let openCamera: YRProposerAction = { [weak vc] in
                guard UIImagePickerController.isSourceTypeAvailable(.Camera)
                    else {
                        vc?.cannotAllowedToAcessCamera()
                        return
                }
                if let strongSelf = vc {
                    imagePicker.sourceType = .Camera
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            yr_proposeToAuth(.Camera, agreed: openCamera, rejected: {
                vc.cannotAllowedToAcessCamera()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
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
                        vc?.cannotAllowedToAcessCameraRoll()
                        return
                }
                
                if let strongSelf = vc {
                    
                    imagePicker.sourceType = .PhotoLibrary
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            
            yr_proposeToAuth(.Camera, agreed: cameraRollAction, rejected: {
                vc.cannotAllowedToAcessCamera()
            })
        }
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "相机", style: .Default) { action in
            let openCamera: YRProposerAction = { [weak vc] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.Camera)
                    else {
                        vc?.cannotAllowedToAcessCamera()
                        return
                }
                
                if let strongSelf = vc {
                    imagePicker.sourceType = .Camera
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            
            }
            
            yr_proposeToAuth(.Camera, agreed: openCamera, rejected: {
                vc.cannotAllowedToAcessCamera()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
    
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     弹出alert“从相册选择” 或 “相机”, __单选图片__
     
     - parameter  参数T : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
     
     __Notice:__  ViewController extention 需要遵守UIImagePickerControllerDelegate, UINavigationControllerDelegate协议，并自己实现方法
     */
    internal class func photoSinglePickerFromAlertFrontCam<T : UIViewController where T:UIImagePickerControllerDelegate, T: UINavigationControllerDelegate> (inViewController viewController: T) {
        
        let vc = viewController
        let imagePicker = YRSignalImagePicker.sigalPicker
        imagePicker.delegate = vc
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default) { action in
            
            let cameraRollAction: YRProposerAction = { [weak vc] in
                guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
                    else {
                        vc?.cannotAllowedToAcessCameraRoll()
                        return
                }
                
                if let strongSelf = vc {
                    
                    imagePicker.sourceType = .PhotoLibrary
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            
            yr_proposeToAuth(.Camera, agreed: cameraRollAction, rejected: {
                vc.cannotAllowedToAcessCamera()
            })
        }
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "相机", style: .Default) { action in
            let openCamera: YRProposerAction = { [weak vc] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.Camera)
                    else {
                        vc?.cannotAllowedToAcessCamera()
                        return
                }
                
                if let strongSelf = vc {
                    imagePicker.sourceType = .Camera
                    imagePicker.cameraDevice = .Front
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            
            yr_proposeToAuth(.Camera, agreed: openCamera, rejected: {
                vc.cannotAllowedToAcessCamera()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            alertController.dismissViewControllerAnimated(true, completion: nil)
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
    internal class func photoMultiPickerFromAlert<T : UIViewController where T:UIImagePickerControllerDelegate, T: UINavigationControllerDelegate> (inViewController viewController: T, limited maxNum: Int, callBack:( (images: [UIImage]) -> Void)) {
        
        let vc = viewController
        let imagePicker = YRSignalImagePicker.sigalPicker
        imagePicker.delegate = vc
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default) { action in
            
            yr_proposeToAuth(.Photos, agreed: {
                let imagePickerVC: YRPhotoPickerViewController = YRPhotoPickerViewController()
                imagePickerVC.maxSelectedNum = maxNum
                
                imagePickerVC.completion = { photoAssetsSet in
                    print( " received photo Set asset here "  )
                    
                    var images = [UIImage]()
                    
                    let imageManager = PHCachingImageManager()
                    let options = PHImageRequestOptions()
                    options.synchronous = true // synchronous
                    options.version = .Current
                    options.deliveryMode = .HighQualityFormat
                    options.resizeMode = .Exact
                    options.networkAccessAllowed = true // from iclould
                    for imageAsset in  photoAssetsSet {
                        
                        let targetSize: CGSize
                        let maxSize: CGFloat = 750
                        let pixelWidth = CGFloat(imageAsset.pixelWidth)
                        let pixelHeight = CGFloat(imageAsset.pixelHeight)
                        if pixelWidth > pixelHeight {
                            let width = maxSize
                            let height = floor(maxSize * (pixelHeight / pixelWidth))
                            targetSize = CGSize(width: width, height: height)
                        } else {
                            let height = maxSize
                            let width = floor(maxSize * (pixelWidth / pixelHeight))
                            targetSize = CGSize(width: width, height: height)
                        }
                        
                        imageManager.requestImageDataForAsset(imageAsset, options: options, resultHandler: { (data, String, imageOrientation, _) -> Void in
                            if let data = data, image = UIImage(data: data) {
                                if let image = image.resizeToSize(targetSize, withInterpolationQuality: .Medium) {
                                    images.append(image)
                                }
                            }
                        })
                    }
                    callBack(images: images)
                }
                vc.navigationController?.pushViewController(imagePickerVC, animated: true)
            }, rejected: {
                vc.cannotAllowedToAcessCameraRoll()
            })
            
        }
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "相机", style: .Default) { action in
            let openCamera: YRProposerAction = { [weak vc] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.Camera)
                    else {
                        vc?.cannotAllowedToAcessCamera()
                        return
                }
                
                if let strongSelf = vc {
                    imagePicker.sourceType = .Camera
                    strongSelf.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
            }
            
            yr_proposeToAuth(.Camera, agreed: openCamera, rejected: {
                vc.cannotAllowedToAcessCamera()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     直接由alert显示多选图片
     
     - parameter  参数T : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
     - parameter  limited: Int 设置一次最多选取的图片数
     
     __Notice:__  ViewController extention 需要遵守UIImagePickerControllerDelegate, UINavigationControllerDelegate协议，并自己实现方法
     */
    internal class func photoMultiPickerDerectilyModeledInAlert <T : UIViewController where T:UIImagePickerControllerDelegate, T: UINavigationControllerDelegate> (inViewController viewController: T, limited maxNum: Int, callBack:((images: [UIImage]) -> Void)) {

        let vc = viewController as UIViewController
        yr_proposeToAuth(.Photos, agreed: {
            let imagePickerVC = YRPhotoPickerAlertLikeViewController()
            imagePickerVC.maxSelectedNum = maxNum
            imagePickerVC.modalPresentationStyle = .Custom;
            imagePickerVC.transitioningDelegate = imagePickerVC
            imagePickerVC.completion = { photoAssetsSet in
                
                print( " received photo Set asset here "  )
                
                var images = [UIImage]()
                
                let imageManager = PHCachingImageManager()
                let options = PHImageRequestOptions()
                options.synchronous = true // 同步
                options.version = .Current
                options.deliveryMode = .HighQualityFormat
                options.resizeMode = .Exact
                options.networkAccessAllowed = true
                for imageAsset in  photoAssetsSet {
                    
                    // size处理，max(w, h) = 1024
                    let targetSize: CGSize
                    let maxSize: CGFloat = 750
                    let pixelWidth = CGFloat(imageAsset.pixelWidth)
                    let pixelHeight = CGFloat(imageAsset.pixelHeight)
                    if pixelWidth > pixelHeight {
                        let width = maxSize
                        let height = floor(maxSize * (pixelHeight / pixelWidth))
                        targetSize = CGSize(width: width, height: height)
                    } else {
                        let height = maxSize
                        let width = floor(maxSize * (pixelWidth / pixelHeight))
                        targetSize = CGSize(width: width, height: height)
                    }
                    
                    print("targetSize: \(targetSize)")
                    
                    imageManager.requestImageDataForAsset(imageAsset, options: options, resultHandler: { (data, String, imageOrientation, _) -> Void in
                        if let data = data, image = UIImage(data: data) {
                            if let image = image.resizeToSize(targetSize, withInterpolationQuality: .Medium) {
                                images.append(image)
                            }
                        }
                    })
                }
                callBack(images: images)
                imagePickerVC.dismissBtnClicked()
            }
            vc.presentViewController(imagePickerVC, animated: true, completion: nil)
            }, rejected: {
                vc.cannotAllowedToAcessCameraRoll()
        })
    }
}


