//
//  BCurrentCityCell.m
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "BCurrentCityCell.h"
#import "BAddressHeader.h"

@implementation BCurrentCityCell

-(CLLocationManager *)locMgr
{
    if (_locMgr == nil) {
        //1、创建位置管理器（定位用户的位置）
        self.locMgr = [[CLLocationManager alloc]init];
        //2、设置代理
        self.locMgr.delegate = self;
    }
    return _locMgr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BG_CELL;
        [self.contentView addSubview:self.GPSButton];
        [self.contentView addSubview:self.activityIndicatorView];
        [self.contentView addSubview:self.label];
//        [self.contentView addSubview:self.locationManager];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self.GPSButton setHidden:YES];
    [self.activityIndicatorView startAnimating];
    _geocoder = [[CLGeocoder alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        //开始定位用户的位置
        //取得定位权限，有两个方法，取决于你的定位使用情况
        //一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
        [self.locMgr requestWhenInUseAuthorization];
        [self.locMgr requestAlwaysAuthorization];
        [self.locMgr startUpdatingLocation];
    }else{
        NSLog(@"无法使用定位服务");
    }
    
}


#pragma mark - 定位的回调方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _meCoordinate = [locations objectAtIndex:0];
    [_geocoder reverseGeocodeLocation:_meCoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark * placeMark = [placemarks objectAtIndex:0];
            NSString * city = placeMark.locality;
            if (!city) {
                city = placeMark.administrativeArea;
            }
            [self.activityIndicatorView stopAnimating];
            [self.label setHidden:YES];
            NSString * addressString = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,city];
            [self.GPSButton setTitle:addressString forState:UIControlStateNormal];
            [self.GPSButton setHidden:NO];
            
        }else if (error ==nil && placemarks.count == 0){
            NSLog(@"没有返回结果");
        }else if (error != nil){
            NSLog(@"有错误产生 = %@",error);
        }
    }];
    [self.locMgr stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event Response
- (void)buttonWhenClick:(void (^)(UIButton *))block{
    self.buttonClickBlock = block;
}

- (void)buttonClick:(UIButton*)button{
    self.buttonClickBlock(button);
}

#pragma mark - Getter and Setter
- (UIButton*)GPSButton{
    if (_GPSButton == nil) {
        _GPSButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _GPSButton.frame = CGRectMake(15, 15 , (ScreenWidth - 10) / 3, BUTTON_HEIGHT);
        [_GPSButton setTitle:@"" forState:UIControlStateNormal];
        _GPSButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _GPSButton.tintColor = [UIColor blackColor];
        _GPSButton.backgroundColor = [UIColor whiteColor];
        _GPSButton.alpha = 0.8;
        _GPSButton.layer.borderColor = [UIColorFromRGBA(237, 237, 237, 1.0) CGColor];
        _GPSButton.layer.borderWidth = 1;
        _GPSButton.layer.cornerRadius = 3;
        [_GPSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _GPSButton;
}

- (UIActivityIndicatorView*)activityIndicatorView{
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 15, BUTTON_HEIGHT, BUTTON_HEIGHT)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.color = [UIColor grayColor];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

- (UILabel*)label{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15 + BUTTON_HEIGHT, 15, BUTTON_WIDTH, BUTTON_HEIGHT)];
        _label.text = @"定位中...";
        _label.font = [UIFont systemFontOfSize:16.0f];
    }
    return _label;
}

//- (LNLocationManager*)locationManager{
//    if (_locationManager == nil) {
//        _locationManager = [[LNLocationManager alloc] init];
//    }
//    return _locationManager;
//}

//- (LNSearchManager*)searchManager{
//    if (_searchManager == nil) {
//        _searchManager = [[LNSearchManager alloc] init];
//    }
//    return _searchManager;
//}

@end
