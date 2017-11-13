//
//  InternetLoanStatisticsView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/9/12.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "InternetLoanStatisticsView.h"
@interface InternetLoanStatisticsView()
{
    UILabel *totalUseCreditDescLabel;
    UILabel *totalUseCreditLabel;
    UILabel *monthCreditDescLabel;
    UILabel *monthCreditLabel;
    UILabel *overdueDescLabel;
    UILabel *overdueLabel;
    
    UIView *lineView1;
    UIView *lineView2;
}
@end

@implementation InternetLoanStatisticsView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        totalUseCreditDescLabel = [[UILabel alloc] init];
        [totalUseCreditDescLabel setText:@"当年用信(千元)"];
        [totalUseCreditDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [totalUseCreditDescLabel setTextAlignment:NSTextAlignmentCenter];
        [totalUseCreditDescLabel setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
        [self addSubview:totalUseCreditDescLabel];
        
        totalUseCreditLabel = [[UILabel alloc] init];
        [totalUseCreditLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [totalUseCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:NO]]];
        [totalUseCreditLabel setTextAlignment:NSTextAlignmentCenter];
        [totalUseCreditLabel setText:@"0"];
        [self addSubview:totalUseCreditLabel];
        
        monthCreditDescLabel = [[UILabel alloc] init];
        [monthCreditDescLabel setText:@"当月用信(千元)"];
        [monthCreditDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [monthCreditDescLabel setTextAlignment:NSTextAlignmentCenter];
        [monthCreditDescLabel setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
        [self addSubview:monthCreditDescLabel];
        
        monthCreditLabel = [[UILabel alloc] init];
        [monthCreditLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [monthCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:NO]]];
        [monthCreditLabel setTextAlignment:NSTextAlignmentCenter];
        [monthCreditLabel setText:@"0"];
        [self addSubview:monthCreditLabel];
        
        overdueDescLabel = [[UILabel alloc] init];
        [overdueDescLabel setText:@"当月逾期(千元)"];
        [overdueDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:NO]]];
        [overdueDescLabel setTextAlignment:NSTextAlignmentCenter];
        [overdueDescLabel setTextColor:[UIColor colorFromHexString:@"#BBBBBB"]];
        [self addSubview:overdueDescLabel];
        
        overdueLabel = [[UILabel alloc] init];
        [overdueLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [overdueLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:NO]]];
        [overdueLabel setTextAlignment:NSTextAlignmentCenter];
        [overdueLabel setText:@"0"];
        [self addSubview:overdueLabel];
        
        lineView1 = [[UIView alloc] init];
        [lineView1 setBackgroundColor:[UIColor colorFromHexString:@"#F1F1F1"]];
        [self addSubview:lineView1];
        
        lineView2 = [[UIView alloc] init];
        [lineView2 setBackgroundColor:[UIColor colorFromHexString:@"#F1F1F1"]];
        [self addSubview:lineView2];
    }
    return self;
}

-(void)makeConstrains
{
    [monthCreditDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:27.0f]);
        make.centerX.equalTo(self);
        make.height.equalTo(@(17));
    }];
    
    [monthCreditLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthCreditDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:7.0f]);
        make.leading.equalTo(monthCreditDescLabel.leading);
        make.trailing.equalTo(monthCreditDescLabel.trailing);
        make.height.equalTo(@(17));
    }];
    
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthCreditDescLabel.top);
        make.bottom.equalTo(monthCreditLabel.bottom);
        make.width.equalTo(@(1));
        make.trailing.equalTo(monthCreditDescLabel.leading).offset(-[UIDevice adaptLengthWithIphone6Length:18.0f]);
    }];
    
    [totalUseCreditDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthCreditDescLabel.top);
        make.height.equalTo(@(17));
        make.trailing.equalTo(lineView1.leading).offset(-[UIDevice adaptLengthWithIphone6Length:18.0f]);
    }];
    
    [totalUseCreditLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalUseCreditDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:7.0f]);
        make.leading.equalTo(totalUseCreditDescLabel.leading);
        make.trailing.equalTo(totalUseCreditDescLabel.trailing);
        make.height.equalTo(@(17));
    }];
    
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthCreditDescLabel.top);
        make.bottom.equalTo(monthCreditLabel.bottom);
        make.width.equalTo(@(1));
        make.leading.equalTo(monthCreditDescLabel.trailing).offset([UIDevice adaptLengthWithIphone6Length:18.0f]);
    }];
    
    
    [overdueDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthCreditDescLabel.top);
        make.height.equalTo(@(17));
        make.leading.equalTo(lineView2.trailing).offset([UIDevice adaptLengthWithIphone6Length:18.0f]);
    }];
    
    [overdueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(overdueDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:7.0f]);
        make.leading.equalTo(overdueDescLabel.leading);
        make.trailing.equalTo(overdueDescLabel.trailing);
        make.height.equalTo(@(17));
    }];
}

-(void)setTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    [totalUseCreditLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",useCredit]]]];
    [monthCreditLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalCurrentMonthUseCredit]]]];
    [overdueLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalOverdueAmount]]]];
}

@end
