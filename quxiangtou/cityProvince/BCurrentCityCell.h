//
//  BCurrentCityCell.h
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//



//当前城市
#import <UIKit/UIKit.h>
//#import "LNLocationManager.h"
//#import "LNSearchManager.h"
#import <CoreLocation/CoreLocation.h>

@interface BCurrentCityCell : UITableViewCell<CLLocationManagerDelegate>

@property (nonatomic, strong) UIButton *GPSButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UILabel *label;

//@property (nonatomic, strong) LNLocationManager *locationManager;

//@property (nonatomic, strong) LNSearchManager *searchManager;

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *button);

@property (nonatomic, strong) CLLocationManager * locMgr;
@property (nonatomic, strong) CLGeocoder * geocoder;  //iOS 5.0 及5.0以上SDK版本使用
@property (nonatomic, strong) CLLocation * meCoordinate;

- (void)buttonWhenClick:(void(^)(UIButton *button))block;

@end
