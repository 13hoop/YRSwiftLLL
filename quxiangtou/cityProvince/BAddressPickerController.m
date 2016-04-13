//
//  BAddressPickerController.m
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "BAddressPickerController.h"
#import "ChineseToPinyin.h"
#import "BAddressHeader.h"
#import "BCurrentCityCell.h"
#import "BRecentCityCell.h"
#import "BHotCityCell.h"

#import "ChineseString.h"
//#import "pinyin.h"


@interface BAddressPickerController ()<UISearchBarDelegate,UISearchDisplayDelegate,BAddressPickerDelegate,BAddressPickerDataSource>{
    
    UITableView *_tableView;
    UISearchBar *_searchBar;
  UISearchDisplayController *_displayController;
    NSArray *hotCities;
    NSMutableArray *cities;
    NSMutableArray *titleArray;
    NSMutableArray *resultArray;
    
    NSMutableArray * _arr;
    NSMutableArray * _arr1;
    NSMutableArray * _arr2;
    NSMutableArray * _arr3;
    NSMutableArray * _arr4;
    NSMutableArray * _arr5;
    NSMutableArray * _arr6;
    NSMutableArray * _arr7;
    NSMutableArray * _arr8;
    NSMutableArray * _arr9;
    NSMutableArray * _arr10;
    NSMutableArray * _arr11;
    NSMutableArray * _arr12;
    NSMutableArray * _arr13;
    NSMutableArray * _arr14;
    NSMutableArray * _arr15;
    NSMutableArray * _arr16;
    NSMutableArray * _arr17;
    NSMutableArray * _arr18;
    NSMutableArray * _arr19;
    NSMutableArray * _arr20;
    NSMutableArray * _arr21;
    NSMutableArray * _arr22;
    NSMutableArray * _arr23;
    NSMutableArray * _arr24;
    NSMutableArray * _arr25;
    NSMutableArray * _arr26;
    NSDictionary * dic;
    
}

@property(nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic,strong) NSMutableArray * stringToSort;

@end

@implementation BAddressPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dictionary = [[NSMutableDictionary alloc]init];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 39);
    [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btn_right, nil];
    self.navigationItem.title = @"城市列表";
   
    _arr=[[NSMutableArray alloc]init];
    _arr1=[[NSMutableArray alloc]init];
    _arr2=[[NSMutableArray alloc]init];
    _arr3=[[NSMutableArray alloc]init];
    _arr4=[[NSMutableArray alloc]init];
    _arr5=[[NSMutableArray alloc]init];
    _arr6=[[NSMutableArray alloc]init];
    _arr7=[[NSMutableArray alloc]init];
    _arr8=[[NSMutableArray alloc]init];
    _arr9=[[NSMutableArray alloc]init];
    _arr10=[[NSMutableArray alloc]init];
    _arr11=[[NSMutableArray alloc]init];
    _arr12=[[NSMutableArray alloc]init];
    _arr13=[[NSMutableArray alloc]init];
    _arr14=[[NSMutableArray alloc]init];
    _arr15=[[NSMutableArray alloc]init];
    _arr16=[[NSMutableArray alloc]init];
    _arr17=[[NSMutableArray alloc]init];
    _arr18=[[NSMutableArray alloc]init];
    _arr19=[[NSMutableArray alloc]init];
    _arr20=[[NSMutableArray alloc]init];
    _arr21=[[NSMutableArray alloc]init];
    _arr22=[[NSMutableArray alloc]init];
    _arr23=[[NSMutableArray alloc]init];
    _arr24=[[NSMutableArray alloc]init];
    _arr25=[[NSMutableArray alloc]init];
    
    
    _stringToSort = [[NSMutableArray alloc]initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] objectForKey:@"all"]];
    [self stringToSortTwo];

    
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)stringToSortTwo
{
    NSMutableArray * chineseStringArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_stringToSort count]; i++) {
        ChineseString * chineseString = [[ChineseString alloc] init];
        chineseString.string = [NSString stringWithString:[_stringToSort objectAtIndex:i]];
        if (chineseString.string == nil) {
            chineseString.string = @"";
        }
        if (![chineseString.string isEqualToString:@""]) {
            NSString * pinYinResult = [NSString string];
            for (int j = 0; j < chineseString.string.length; j++) {
                NSString * singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringArray addObject:chineseString];
    }
    //step2:按照拼音首字母对string进行排序
    NSArray * sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringArray sortUsingDescriptors:sortDescriptors];
    
    //step3:输出
    for (int i = 0; i < [chineseStringArray count]; i++) {
        ChineseString * chineseString = [chineseStringArray objectAtIndex:i];
        NSString * str = [NSString stringWithFormat:@"%@",chineseString.pinYin];
        NSString * s = [str substringToIndex:1];
        if ([s isEqualToString:@"A"]) {
            [_arr addObject:chineseString.string];
        }
        if (_arr.count == 0) {
            [_dictionary removeObjectForKey:@"A"];
        } else {
            [_dictionary setValue:_arr forKey:@"A"];
        }
        
        if ([s isEqualToString:@"B"]) {
            [_arr1 addObject:chineseString.string];
        }
        if (_arr1.count == 0) {
            [_dictionary removeObjectForKey:@"B"];
        } else {
            [_dictionary setValue:_arr1 forKey:@"B"];
        }
        
        if ([s isEqualToString:@"C"]) {
            [_arr2 addObject:chineseString.string];
        }
        if ([_arr2 count]==0) {
            [_dictionary removeObjectForKey:@"C"];
        } else {
            [_dictionary setValue:_arr2 forKey:@"C"];
        }
        
        if ([s isEqualToString:@"D"]) {
            [_arr3 addObject:chineseString.string];
        }
        if ([_arr3 count]==0) {
            [_dictionary removeObjectForKey:@"D"];
        } else {
            [_dictionary setValue:_arr3 forKey:@"D"];
        }
        
        if ([s isEqualToString:@"E"]) {
            [_arr4 addObject:chineseString.string];
        }
        if ([_arr4 count]==0) {
            [_dictionary removeObjectForKey:@"E"];
        } else {
            [_dictionary setValue:_arr4 forKey:@"E"];
        }
        
        if ([s isEqualToString:@"F"]) {
            [_arr5 addObject:chineseString.string];
        }
        if ([_arr5 count]==0) {
            [_dictionary removeObjectForKey:@"F"];
        } else {
            [_dictionary setValue:_arr5 forKey:@"F"];
        }
        
        if ([s isEqualToString:@"G"]) {
            [_arr6 addObject:chineseString.string];
        }
        if ([_arr6 count]==0) {
            [_dictionary removeObjectForKey:@"G"];
        } else {
            [_dictionary setValue:_arr6 forKey:@"G"];
        }
        
        if ([s isEqualToString:@"H"]) {
            [_arr7 addObject:chineseString.string];
        }
        if ([_arr7 count]==0) {
            [_dictionary removeObjectForKey:@"H"];
        } else {
            [_dictionary setValue:_arr7 forKey:@"H"];
        }
        
        if ([s isEqualToString:@"I"]) {
            [_arr8 addObject:chineseString.string];
        }
        if ([_arr8 count]==0) {
            [_dictionary removeObjectForKey:@"I"];
        } else {
            [_dictionary setValue:_arr8 forKey:@"I"];
        }
        
        if ([s isEqualToString:@"J"]) {
            [_arr9 addObject:chineseString.string];
        }
        if ([_arr9 count]==0) {
            [_dictionary removeObjectForKey:@"J"];
        } else {
            [_dictionary setValue:_arr9 forKey:@"J"];
        }
        
        if ([s isEqualToString:@"K"]) {
            [_arr10 addObject:chineseString.string];
        }
        if ([_arr10 count]==0) {
            [_dictionary removeObjectForKey:@"K"];
        } else {
            [_dictionary setValue:_arr10 forKey:@"K"];
        }
        
        if ([s isEqualToString:@"L"]) {
            [_arr11 addObject:chineseString.string];
        }
        if ([_arr11 count]==0) {
            [_dictionary removeObjectForKey:@"L"];
        } else {
            [_dictionary setValue:_arr11 forKey:@"L"];
        }
        
        if ([s isEqualToString:@"M"]) {
            [_arr12 addObject:chineseString.string];
        }
        if ([_arr12 count]==0) {
            [_dictionary removeObjectForKey:@"M"];
        } else {
            [_dictionary setValue:_arr12 forKey:@"M"];
        }
        
        if ([s isEqualToString:@"N"]) {
            [_arr13 addObject:chineseString.string];
        }
        if ([_arr13 count]==0) {
            [_dictionary removeObjectForKey:@"N"];
        } else {
            [_dictionary setValue:_arr13 forKey:@"N"];
        }
        
        if ([s isEqualToString:@"O"]) {
            [_arr14 addObject:chineseString.string];
        }
        if ([_arr14 count]==0) {
            [_dictionary removeObjectForKey:@"O"];
        } else {
            [_dictionary setValue:_arr14 forKey:@"O"];
        }
        
        if ([s isEqualToString:@"P"]) {
            [_arr15 addObject:chineseString.string];
        }
        if ([_arr15 count]==0) {
            [_dictionary removeObjectForKey:@"P"];
        } else {
            [_dictionary setValue:_arr15 forKey:@"P"];
        }
        
        if ([s isEqualToString:@"Q"]) {
            [_arr16 addObject:chineseString.string];
        }
        if ([_arr16 count]==0) {
            [_dictionary removeObjectForKey:@"Q"];
        } else {
            [_dictionary setValue:_arr16 forKey:@"Q"];
        }
        
        if ([s isEqualToString:@"R"]) {
            [_arr17 addObject:chineseString.string];
        }
        if ([_arr17 count]==0) {
            [_dictionary removeObjectForKey:@"R"];
        } else {
            [_dictionary setValue:_arr17 forKey:@"R"];
        }
        
        if ([s isEqualToString:@"S"]) {
            [_arr18 addObject:chineseString.string];
        }
        if ([_arr18 count]==0) {
            [_dictionary removeObjectForKey:@"S"];
        } else {
            [_dictionary setValue:_arr18 forKey:@"S"];
        }
        
        if ([s isEqualToString:@"T"]) {
            [_arr19 addObject:chineseString.string];
        }
        if ([_arr19 count]==0) {
            [_dictionary removeObjectForKey:@"T"];
        } else {
            [_dictionary setValue:_arr19 forKey:@"T"];
        }
        
        if ([s isEqualToString:@"U"]) {
            [_arr20 addObject:chineseString.string];
        }
        if ([_arr20 count]==0) {
            [_dictionary removeObjectForKey:@"U"];
        } else {
            [_dictionary setValue:_arr20 forKey:@"U"];
        }
        
        if ([s isEqualToString:@"V"]) {
            [_arr21 addObject:chineseString.string];
        }
        if ([_arr21 count]==0) {
            [_dictionary removeObjectForKey:@"V"];
        } else {
            [_dictionary setValue:_arr21 forKey:@"V"];
        }
        
        if ([s isEqualToString:@"W"]) {
            [_arr22 addObject:chineseString.string];
        }
        if ([_arr22 count]==0) {
            [_dictionary removeObjectForKey:@"W"];
        } else {
            [_dictionary setValue:_arr22 forKey:@"W"];
        }
        
        if ([s isEqualToString:@"X"]) {
            [_arr23 addObject:chineseString.string];
        }
        if ([_arr23 count]==0) {
            [_dictionary removeObjectForKey:@"X"];
        } else {
            [_dictionary setValue:_arr23 forKey:@"X"];
        }
        
        if ([s isEqualToString:@"Y"]) {
            [_arr24 addObject:chineseString.string];
        }
        if ([_arr24 count]==0) {
            [_dictionary removeObjectForKey:@"Y"];
        } else {
            [_dictionary setValue:_arr24 forKey:@"Y"];
        }
        if ([s isEqualToString:@"Z"]) {
            [_arr25 addObject:chineseString.string];
        }
        if ([_arr25 count]==0) {
            [_dictionary removeObjectForKey:@"Z"];
        } else {
            [_dictionary setValue:_arr25 forKey:@"Z"];
        }
        
    }
    cities = [[NSMutableArray alloc] init];
    NSArray *allCityKeys = [self.dictionary allKeys];
    for (int i = 0; i < [self.dictionary count]; i++) {
        [cities addObjectsFromArray:[self.dictionary objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        if (i == 8 || i == 14 || i == 20 || i== 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [titleArray addObject:cityKey];
    }
    [_tableView reloadData];
}

/**
 *  初始化方法
 *
 *  @param frame
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        //适配ios7
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        {
            self.navigationController.navigationBar.translucent = NO;
        }
//        [self initData];
        [self initSearchBar];
        [self initTableView];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:currentCity];
    }
    return self;
}

#pragma mark - Getter and Setter
- (void)setDataSource:(id<BAddressPickerDataSource>)dataSource{
    hotCities = [[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] objectForKey:@"hot"];
    [_tableView reloadData];
}

#pragma mark - UISearchBar Delegate
/**
 *  搜索开始回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view setBackgroundColor:UIColorFromRGBA(198, 198, 203, 1.0)];
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
                }
            }];
        }
    }
    return YES;
}

/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(endSearch:)]) {
        [self.delegate endSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            } completion:^(BOOL finished) {
                [self.view setBackgroundColor:[UIColor whiteColor]];
            }];
        }
    }
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [resultArray removeAllObjects];
    for (int i = 0; i < cities.count; i++) {
        if ([[ChineseToPinyin pinyinFromChiniseString:cities[i]] hasPrefix:[searchString uppercaseString]] || [cities[i] hasPrefix:searchString]) {
            [resultArray addObject:[cities objectAtIndex:i]];
        }
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return [[self.dictionary allKeys] count] + 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section > 1) {
            NSString *cityKey = [titleArray objectAtIndex:section - 2];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            return [array count];
        }
        return 1;
    }else{
        return [resultArray count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            BCurrentCityCell *currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
            if (currentCityCell == nil) {
                currentCityCell = [[BCurrentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currentCityCell"];
            }
            currentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return currentCityCell;
        }
        else if (indexPath.section == 1){
            BHotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCityCell"];
            if (hotCell == nil) {
                hotCell = [[BHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell" array:hotCities];
            }
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return hotCell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString *Identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if ([cell isKindOfClass:[BCurrentCityCell class]]) {
            [(BCurrentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }

        else if([cell isKindOfClass:[BHotCityCell class]]){
            [(BHotCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else{
            NSString *cityKey = [titleArray objectAtIndex:indexPath.section - 2];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }

    }else{
        cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"当前",@"热门", nil];
        for (int i = 0; i < [titleArray count]; i++) {
            NSString *title = [NSString stringWithFormat:@"    %@",[titleArray objectAtIndex:i]];
            [titleSectionArray addObject:title];
        }
        return titleSectionArray;
    }else{
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
        headerView.backgroundColor = UIColorFromRGBA(235, 235, 235, 1.0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 28)];
        label.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:label];
        if (section == 0) {
            label.text = @"当前城市";
        }
//        else if (section == 1){
//            //如果第一次使用没有最近访问的城市则赢该行
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
//                return nil;
//            }
//            label.text = @"最近访问城市";
//        }
        else if (section == 1){
            label.text = @"热门城市";
        }else{
            label.text = [titleArray objectAtIndex:section - 2];
        }
        return headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
//        if (section == 1) {
//            //如果第一次使用没有最近访问的城市则赢该行
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
//                return 0.01;
//            }
//        }
        return 28;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        //如果第一次使用没有最近访问的城市则赢该行
//        if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
//            return 0.01;
//        }
//    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 1) {
            return ceil((float)[hotCities count] / 3) * (BUTTON_HEIGHT + 15) + 15;
        }else if (indexPath.section > 1){
            return 42;
        }
//        else if (indexPath.section == 1){
//            //如果第一次使用没有最近访问的城市则赢该行
//            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
//                return 0;
//            }
//        }
        return BUTTON_HEIGHT + 30;
    }else{
        return 42;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        if (indexPath.section > 1) {
            NSString *cityKey = [titleArray objectAtIndex:indexPath.section - 2];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self.delegate addressPicker:self didSelectedCity:[array objectAtIndex:indexPath.row]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
//            [self saveCurrentCity:[resultArray objectAtIndex:indexPath.row]];
            [self.delegate addressPicker:self didSelectedCity:[resultArray objectAtIndex:indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//保存访问过的城市
- (void)saveCurrentCity:(NSString*)city{
    NSMutableArray *currentArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:currentCity]];
    if (currentArray == nil) {
        currentArray = [NSMutableArray array];
    }
    if ([currentArray count] < 2 && ![currentArray containsObject:city]) {
        [currentArray addObject:city];
    }else{
        if (![currentArray containsObject:city]) {
            currentArray[1] = currentArray[0];
            currentArray[0] = city;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentArray forKey:currentCity];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - init
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    [self.view addSubview:_tableView];
}

- (void)initSearchBar{
    resultArray = [[NSMutableArray alloc] init];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.placeholder = @"输入城市名或拼音";
    _searchBar.delegate = self;
    _searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
    [self.view addSubview:_searchBar];
}

//- (void)initData{
//    cities = [[NSMutableArray alloc] init];
//    NSArray *allCityKeys = [self.dictionary allKeys];
//    for (int i = 0; i < [self.dictionary count]; i++) {
//        [cities addObjectsFromArray:[self.dictionary objectForKey:[allCityKeys objectAtIndex:i]]];
//    }
//    titleArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 26; i++) {
//        if (i == 8 || i == 14 || i == 20 || i== 21) {
//            continue;
//        }
//        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
//        [titleArray addObject:cityKey];
//    }
//}




@end
