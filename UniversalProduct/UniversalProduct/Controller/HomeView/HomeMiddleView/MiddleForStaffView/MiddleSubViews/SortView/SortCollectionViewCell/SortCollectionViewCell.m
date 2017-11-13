//
//  SortCollectionViewCell.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "SortCollectionViewCell.h"
#import "RankInfo.h"
@interface SortCollectionViewCell()
{
    UIView *shadowView;
    UIView *backgroundView;
    UIImageView *iconImageView;
    UILabel *nameLabel;
    UILabel *monthCreditLabel;
}
@end
@implementation SortCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        shadowView = [[UIView alloc] init];
        [shadowView setBackgroundColor:[UIColor whiteColor]];
        shadowView.layer.shadowColor = [UIColor colorFromHexString:@"#E3E3E3"].CGColor;
        shadowView.layer.shadowOpacity = 0.3;
        [shadowView.layer setShadowOffset:CGSizeMake(-1, -1)];
        [self addSubview:shadowView];
        
        backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        backgroundView.layer.shadowColor = [UIColor colorFromHexString:@"#E3E3E3"].CGColor;
        backgroundView.layer.shadowOpacity = 0.3;
        [backgroundView.layer setShadowOffset:CGSizeMake(1, 1)];
        [self addSubview:backgroundView];
        
        iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sortFirstIconImage"]];
        [backgroundView addSubview:iconImageView];
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setText:@""];
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [nameLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [backgroundView addSubview:nameLabel];
        
        monthCreditLabel = [[UILabel alloc] init];
        [monthCreditLabel setText:@""];
        [monthCreditLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [monthCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [monthCreditLabel setTextAlignment:NSTextAlignmentLeft];
        [backgroundView addSubview:monthCreditLabel];
        
        [self makeConstrains];
        
    }
    return self;
}

-(void)makeConstrains
{
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:20.0f]);
        make.bottom.equalTo(self).offset(-[UIDevice adaptLengthWithIphone6Length:20.0f]);
    }];
    
    [shadowView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backgroundView.leading);
        make.trailing.equalTo(backgroundView.trailing);
        make.top.equalTo(backgroundView.top);
        make.bottom.equalTo(backgroundView.bottom);
    }];

    
    UIImage *icon = [UIImage imageNamed:@"sortFirstIconImage"];
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backgroundView.leading).offset(19);
        make.centerY.equalTo(backgroundView.centerY);
        make.width.equalTo(@(icon.size.width));
        make.height.equalTo(@(icon.size.height));
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconImageView.trailing).offset(10);
        make.centerY.equalTo(backgroundView.centerY).offset(-10);
        make.height.equalTo(@(18));
        make.trailing.equalTo(backgroundView.trailing);
    }];
    
    [monthCreditLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nameLabel.leading);
        make.trailing.equalTo(nameLabel.trailing);
        make.height.equalTo(@(18));
        make.centerY.equalTo(backgroundView.centerY).offset(10);
    }];
}

-(void)setupCellWithRankInfo:(RankInfo *)info
{
    if (info.rank == 1) {
        [iconImageView setImage:[UIImage imageNamed:@"sortFirstIconImage"]];
    }else if (info.rank == 2){
        [iconImageView setImage:[UIImage imageNamed:@"sortSecondIconImage"]];
    }else if (info.rank == 3){
        [iconImageView setImage:[UIImage imageNamed:@"sortThirdIconImage"]];
    }else{
        [iconImageView setImage:[UIImage imageNamed:@"sortOtherIconImage"]];
    }
    [nameLabel setText:info.employeeName];
    [monthCreditLabel setText:[NSString stringWithFormat:@"%@千元",[AppUtils transferStringNumberToString:info.useAmount]]];
}
@end
