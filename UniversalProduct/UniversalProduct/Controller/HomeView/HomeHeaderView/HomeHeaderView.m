//
//  HomeHeaderView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "HomeHeaderView.h"
@interface HomeHeaderView()
{
    UILabel *totalCreditDescLabel;
    UILabel *totalCreditLabel;
    UILabel *totalUseCreditDescLabel;
    UILabel *totalUseCreditLabel;
    
    UIView *lineView;
}
@end
@implementation HomeHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.contents = (id)[UIImage imageNamed:@"headBackgroundImage"].CGImage;
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor colorFromHexString:@"#F1F1F1" opacity:0.6]];
        [self addSubview:lineView];
        
        totalCreditDescLabel  = [[UILabel alloc] init];
        [totalCreditDescLabel setText:@"历史授信(千元)"];
        [totalCreditDescLabel setTextColor:[UIColor whiteColor]];
        [totalCreditDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]];
        [totalCreditDescLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:totalCreditDescLabel];
        [totalCreditDescLabel sizeToFit];
        
        totalCreditLabel = [[UILabel alloc] init];
        [totalCreditLabel setText:@"0"];
        [totalCreditLabel setTextColor:[UIColor whiteColor]];
        [totalCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:18.0f needFixed:NO]]];
        [totalCreditLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:totalCreditLabel];
        [totalCreditLabel sizeToFit];
        
        totalUseCreditDescLabel  = [[UILabel alloc] init];
        [totalUseCreditDescLabel setText:@"历史用信(千元)"];
        [totalUseCreditDescLabel setTextColor:[UIColor whiteColor]];
        [totalUseCreditDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:14.0f needFixed:NO]]];
        [totalUseCreditDescLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:totalUseCreditDescLabel];
        [totalUseCreditDescLabel sizeToFit];
        
        totalUseCreditLabel = [[UILabel alloc] init];
        [totalUseCreditLabel setText:@"0"];
        [totalUseCreditLabel setTextColor:[UIColor whiteColor]];
        [totalUseCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:18.0f needFixed:NO]]];
        [totalUseCreditLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:totalUseCreditLabel];
        [totalUseCreditLabel sizeToFit];
    }
    return self;
}

-(void)makeConstraints
{
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 35.0f));
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:92.0f]);
        make.centerX.equalTo(self.centerX);
    }];
    
    [totalCreditDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(lineView.leading).offset(-[UIDevice adaptLengthWithIphone6Length:37.0f]);
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:86.0f]);
        make.height.equalTo(@(20));
    }];
    
    [totalCreditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(totalCreditDescLabel.trailing);
        make.leading.equalTo(totalCreditDescLabel.leading);
        make.top.equalTo(totalCreditDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:5]);
        make.height.equalTo(@(25));
    }];
    
    [totalUseCreditDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lineView.trailing).offset([UIDevice adaptLengthWithIphone6Length:37.0f]);
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:86.0f]);
        make.height.equalTo(@(20));
    }];
    
    [totalUseCreditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(totalUseCreditDescLabel.trailing);
        make.leading.equalTo(totalUseCreditDescLabel.leading);
        make.top.equalTo(totalUseCreditDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:5]);
        make.height.equalTo(@(25));
    }];

}

-(void)setTotalCredit:(double)totalCredit totalUseCredit:(double)totalUseCredit
{
    [totalUseCreditLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalUseCredit]]]];
    [totalCreditLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalCredit]]]];
}
@end
