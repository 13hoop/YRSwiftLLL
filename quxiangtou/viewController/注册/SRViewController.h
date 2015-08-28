//
//  SRViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AFPickerView.h"
@interface SRViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView * defaultPickerView;
    ASIFormDataRequest * messageRequest;
    ASIFormDataRequest * UpPhotoRequest;
    
}

@end
