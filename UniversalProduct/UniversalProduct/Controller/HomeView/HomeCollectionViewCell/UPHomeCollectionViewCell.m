//
//  UPHomeCollectionViewCell.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/28.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPHomeCollectionViewCell.h"
#import "SystemInfo.h"
#import <WZLBadge/UIView+WZLBadge.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UPHomeCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgPlatform = [[UIImageView alloc] init];
        [_imgPlatform setBadgeBgColor:[UIColor colorFromHexString:@"#FF6E6E"]];
        [_imgPlatform setBadgeMaximumBadgeNumber:99];
        [_imgPlatform setFrame:CGRectMake(0, 0, 32, 30)];
        [_imgPlatform setBadgeCenterOffset:CGPointMake(-4, 3)];
        _imgPlatform.contentMode  = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgPlatform];
        
        _lblPlatformName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 18)];
        [_lblPlatformName setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:NO]]];
        [_lblPlatformName setTextAlignment:NSTextAlignmentCenter];
        [_lblPlatformName setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [self addSubview:_lblPlatformName];
        
        [self makeConstrains];
    }
    return  self;
}

-(void)makeConstrains
{
    [_imgPlatform makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:38.0f]);
        make.width.equalTo(@(32));
        make.height.equalTo(@(30));
        make.centerX.equalTo(self.centerX);
    }];
}

-(void)setupCellWithSystemInfo:(SystemInfo *)info
{
    [_imgPlatform sd_setImageWithURL:[NSURL URLWithString:info.logo] placeholderImage:[UIImage imageNamed:@"DefaultCellIcon"]];
    NSInteger badge = info.todo;
    if (badge > 0) {
        [_imgPlatform showBadgeWithStyle:WBadgeStyleNumber value:badge animationType:WBadgeAnimTypeBreathe];
    }else{
        [_imgPlatform clearBadge];
    }
    
    [_lblPlatformName setText:info.name];
    [_lblPlatformName sizeToFit];
    
    if ([@"灵缇" isEqualToString:info.name]) {
        [_lblPlatformName setCenter:CGPointMake(self.frame.size.width / 2.0 - 2, self.frame.size.height - _lblPlatformName.frame.size.height / 2.0f)];
    }else{
        [_lblPlatformName setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - _lblPlatformName.frame.size.height / 2.0f)];
    }
}
@end
