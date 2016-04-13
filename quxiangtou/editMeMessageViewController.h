//
//  editMeMessageViewController.h
//  quxiangtou
//
//  Created by mac on 16/3/30.
//  Copyright (c) 2016年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editMeMessageViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView * defaultPickerView;
    ASIFormDataRequest * messageRequest;
    ASIFormDataRequest * UpPhotoRequest;
    
}

@end
