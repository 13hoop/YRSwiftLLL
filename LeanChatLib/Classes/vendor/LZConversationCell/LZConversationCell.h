//
//  LeanChatConversationTableViewCell.h
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 lzwjava QQ: 651142978
//

#import <UIKit/UIKit.h>
#import <JSBadgeView/JSBadgeView.h>

@protocol LZConversationCellDelegate;


@interface LZConversationCell : UITableViewCell

+ (CGFloat)heightOfCell;

+ (LZConversationCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView;

+ (void)registerCellToTableView: (UITableView *)tableView ;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel  *messageTextLabel;
@property (nonatomic, strong) JSBadgeView *badgeView;
@property (nonatomic, strong) UIView *litteBadgeView;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UIButton * favoriteFriend;
@property (nonatomic, assign) id<LZConversationCellDelegate> musicDelegate;


@end
@protocol LZConversationCellDelegate <NSObject>

- (void) didClickPlayMusicWithCell:(LZConversationCell *) cell;

@end