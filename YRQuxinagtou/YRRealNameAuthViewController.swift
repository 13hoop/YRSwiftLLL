//
//  YRRealNameAuthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRealNameAuthViewController: UIViewController {

    @IBOutlet weak var photoBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoAction(sender: AnyObject) {
        YRPhotoPicker.photoSinglePickerFromAlert(inViewController: self)
    }
 
    @IBAction func commitClicked(sender: AnyObject) {
    }
    
    
}

extension YRRealNameAuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.photoBtn.setBackgroundImage(image, forState: .Normal)
        
        //        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        //        YRService.updateAvatarImage(data: imageData, success: { [weak self] resule in
        //            dispatch_async(dispatch_get_main_queue()) {
        //                self?.photoBtn.setBackgroundImage(image, forState: .Normal)
        //            }
        //        }) { error in
        //            print("\(#function) error: \(error)")
        //        }
    }
    
}