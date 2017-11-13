//
//  ColdChainsView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "ColdChainsView.h"
#define VerticalDashLineTopMargin 25.0f
#define VerticalDashLineBottomMargin 21.0f
#define DescLabelTopMargin 20.0f
#define LabelBetweenMargin 7.0f
@interface ColdChainsView()
{
    UILabel *titleLabel;
    UILabel *totalUseCreditDescLabel;
    UILabel *totalUseCreditLabel;
    UILabel *totalCreditDescLabel;
    UILabel *totalCreditLabel;
    UILabel *totalpendingDescLabel;
    UILabel *totalpendingLabel;
    UILabel *totalPayedDescLabel;
    UILabel *totalPayedLabel;
    UILabel *totalOverdueDescLabel;
    UILabel *totalOverdueLabel;
    UILabel *loanToCreditRatioDescLabel;
    UILabel *loanToCreditRatioLabel;
    
    UIView *lineView;
    UIView *dashLineView1;
    UIView *dashLineView2;
    UIView *dashLineView3;
    UIView *dashLineView4;
    UIView *dashLineView5;
}
@end
@implementation ColdChainsView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        titleLabel = [[UILabel alloc] init];
        [titleLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [titleLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [titleLabel setText:@"冷链"];
        [self addSubview:titleLabel];
        
        lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor colorFromHexString:@"#F6F6F6"]];
        [self addSubview:lineView];
        
        dashLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, [UIDevice adaptLengthWithIphone6Length:32.0f])];
        [self addSubview:dashLineView1];
        
        totalUseCreditDescLabel = [[UILabel alloc] init];
        [totalUseCreditDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [totalUseCreditDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [totalUseCreditDescLabel setTextAlignment:NSTextAlignmentCenter];
        [totalUseCreditDescLabel setText:@"用信总额(千元)"];
        [self addSubview:totalUseCreditDescLabel];
        
        totalUseCreditLabel = [[UILabel alloc] init];
        [totalUseCreditLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [totalUseCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:YES]]];
        [totalUseCreditLabel setTextAlignment:NSTextAlignmentCenter];
        [totalUseCreditLabel setText:@"0"];
        [self addSubview:totalUseCreditLabel];
        
        totalCreditDescLabel = [[UILabel alloc] init];
        [totalCreditDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [totalCreditDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [totalCreditDescLabel setTextAlignment:NSTextAlignmentCenter];
        [totalCreditDescLabel setText:@"授信总额(千元)"];
        [self addSubview:totalCreditDescLabel];
        
        totalCreditLabel = [[UILabel alloc] init];
        [totalCreditLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [totalCreditLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:YES]]];
        [totalCreditLabel setTextAlignment:NSTextAlignmentCenter];
        [totalCreditLabel setText:@"0"];
        [self addSubview:totalCreditLabel];
        
        dashLineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GDeviceWidth-32, 1)];
        [self addSubview:dashLineView2];
        
        dashLineView3 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1, [UIDevice adaptLengthWithIphone6Length:32.0f])];
        [self addSubview:dashLineView3];
        
        totalpendingDescLabel = [[UILabel alloc] init];
        [totalpendingDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [totalpendingDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [totalpendingDescLabel setTextAlignment:NSTextAlignmentCenter];
        [totalpendingDescLabel setText:@"待还总额(千元)"];
        [self addSubview:totalpendingDescLabel];
        
        totalpendingLabel = [[UILabel alloc] init];
        [totalpendingLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [totalpendingLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:YES]]];
        [totalpendingLabel setTextAlignment:NSTextAlignmentCenter];
        [totalpendingLabel setText:@"0"];
        [self addSubview:totalpendingLabel];
        
        totalPayedDescLabel = [[UILabel alloc] init];
        [totalPayedDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [totalPayedDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [totalPayedDescLabel setTextAlignment:NSTextAlignmentCenter];
        [totalPayedDescLabel setText:@"已还总额(千元)"];
        [self addSubview:totalPayedDescLabel];
        
        totalPayedLabel = [[UILabel alloc] init];
        [totalPayedLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [totalPayedLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:YES]]];
        [totalPayedLabel setTextAlignment:NSTextAlignmentCenter];
        [totalPayedLabel setText:@"0"];
        [self addSubview:totalPayedLabel];
        
        dashLineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GDeviceWidth-32, 1)];
        [self addSubview:dashLineView4];
        
        dashLineView5 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1, [UIDevice adaptLengthWithIphone6Length:32.0f])];
        [self addSubview:dashLineView5];
        
        totalOverdueDescLabel = [[UILabel alloc] init];
        [totalOverdueDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [totalOverdueDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [totalOverdueDescLabel setTextAlignment:NSTextAlignmentCenter];
        [totalOverdueDescLabel setText:@"逾期总额(千元)"];
        [self addSubview:totalOverdueDescLabel];
        
        totalOverdueLabel = [[UILabel alloc] init];
        [totalOverdueLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [totalOverdueLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:YES]]];
        [totalOverdueLabel setTextAlignment:NSTextAlignmentCenter];
        [totalOverdueLabel setText:@"0"];
        [self addSubview:totalOverdueLabel];
        
        loanToCreditRatioDescLabel = [[UILabel alloc] init];
        [loanToCreditRatioDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [loanToCreditRatioDescLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:12.0f needFixed:YES]]];
        [loanToCreditRatioDescLabel setTextAlignment:NSTextAlignmentCenter];
        [loanToCreditRatioDescLabel setText:@"贷授比"];
        [self addSubview:loanToCreditRatioDescLabel];
        
        loanToCreditRatioLabel = [[UILabel alloc] init];
        [loanToCreditRatioLabel setTextColor:[UIColor colorFromHexString:@"#666666"]];
        [loanToCreditRatioLabel setFont:[UIFont systemFontOfSize:[UIDevice adaptFontSizeWithIphone6FontSize:13.0f needFixed:YES]]];
        [loanToCreditRatioLabel setTextAlignment:NSTextAlignmentCenter];
        [loanToCreditRatioLabel setText:@"0%"];
        [self addSubview:loanToCreditRatioLabel];
        
        
    }
    return self;
}

-(void)makeConstraints
{
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:45.0f]);
        make.height.equalTo(@(1));
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
    }];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(18));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset([UIDevice adaptLengthWithIphone6Length:45.0f]/2.0f - 9);
    }];
    
    [dashLineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(1));
        make.height.equalTo(@([UIDevice adaptLengthWithIphone6Length:32.0f]));
        make.top.equalTo(lineView.bottom).offset([UIDevice adaptLengthWithIphone6Length:VerticalDashLineTopMargin]);
        make.centerX.equalTo(self);
    }];
    [AppUtils drawVerticalDashLine:dashLineView1 lineLength:4 lineSpacing:2 lineColor:[UIColor colorFromHexString:@"#E5E5E5"]];
    
    [totalUseCreditDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(dashLineView1.leading);
        make.top.equalTo(lineView.bottom).offset([UIDevice adaptLengthWithIphone6Length:DescLabelTopMargin]);
        make.height.equalTo(@(17.0f));
        make.leading.equalTo(self);
    }];
    
    [totalUseCreditLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalUseCreditDescLabel.leading);
        make.trailing.equalTo(totalUseCreditDescLabel.trailing);
        make.top.equalTo(totalUseCreditDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:LabelBetweenMargin]);
        make.height.equalTo(@(17.0f));
    }];
    
    [totalCreditDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(dashLineView1.trailing);
        make.top.equalTo(lineView.bottom).offset([UIDevice adaptLengthWithIphone6Length:DescLabelTopMargin]);
        make.height.equalTo(@(17.0f));
        make.trailing.equalTo(self);
    }];
    
    [totalCreditLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalCreditDescLabel.leading);
        make.trailing.equalTo(totalCreditDescLabel.trailing);
        make.top.equalTo(totalCreditDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:LabelBetweenMargin]);
        make.height.equalTo(@(17.0f));
    }];
    
    [dashLineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView1.bottom).offset([UIDevice adaptLengthWithIphone6Length:VerticalDashLineBottomMargin]);
        make.height.equalTo(@(1));
        make.leading.equalTo(self.leading).offset(16.0f);
        make.trailing.equalTo(self.trailing).offset(16.0f);
    }];
    [AppUtils drawDashLine:dashLineView2 lineLength:4 lineSpacing:2 lineColor:[UIColor colorFromHexString:@"#E5E5E5"]];
    
    [dashLineView3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView2.bottom).offset([UIDevice adaptLengthWithIphone6Length:VerticalDashLineTopMargin]);
        make.width.equalTo(@(1));
        make.height.equalTo(@([UIDevice adaptLengthWithIphone6Length:32.0f]));
        make.centerX.equalTo(self);
    }];
    [AppUtils drawVerticalDashLine:dashLineView3 lineLength:4 lineSpacing:2 lineColor:[UIColor colorFromHexString:@"#E5E5E5"]];
    
    [totalpendingDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(dashLineView3.leading);
        make.top.equalTo(dashLineView2.bottom).offset([UIDevice adaptLengthWithIphone6Length:DescLabelTopMargin]);
        make.height.equalTo(@(17.0f));
        make.leading.equalTo(self);
    }];
    
    [totalpendingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalpendingDescLabel.leading);
        make.trailing.equalTo(totalpendingDescLabel.trailing);
        make.top.equalTo(totalpendingDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:LabelBetweenMargin]);
        make.height.equalTo(@(17.0f));
    }];
    
    [totalPayedDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(dashLineView3.trailing);
        make.top.equalTo(dashLineView2.bottom).offset([UIDevice adaptLengthWithIphone6Length:DescLabelTopMargin]);
        make.height.equalTo(@(17.0f));
        make.trailing.equalTo(self);
    }];
    
    [totalPayedLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalPayedDescLabel.leading);
        make.trailing.equalTo(totalPayedDescLabel.trailing);
        make.top.equalTo(totalPayedDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:LabelBetweenMargin]);
        make.height.equalTo(@(17.0f));
    }];
    
    [dashLineView4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView3.bottom).offset([UIDevice adaptLengthWithIphone6Length:VerticalDashLineBottomMargin]);
        make.height.equalTo(@(1));
        make.leading.equalTo(self.leading).offset(16.0f);
        make.trailing.equalTo(self.trailing).offset(16.0f);
    }];
    [AppUtils drawDashLine:dashLineView4 lineLength:4 lineSpacing:2 lineColor:[UIColor colorFromHexString:@"#E5E5E5"]];
    
    [dashLineView5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dashLineView4.bottom).offset([UIDevice adaptLengthWithIphone6Length:VerticalDashLineTopMargin]);
        make.width.equalTo(@(1));
        make.height.equalTo(@([UIDevice adaptLengthWithIphone6Length:32.0f]));
        make.centerX.equalTo(self);
    }];
    [AppUtils drawVerticalDashLine:dashLineView5 lineLength:4 lineSpacing:2 lineColor:[UIColor colorFromHexString:@"#E5E5E5"]];
    
    [totalOverdueDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(dashLineView5.leading);
        make.top.equalTo(dashLineView4.bottom).offset([UIDevice adaptLengthWithIphone6Length:DescLabelTopMargin]);
        make.height.equalTo(@(17.0f));
        make.leading.equalTo(self);
    }];
    
    [totalOverdueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(totalOverdueDescLabel.leading);
        make.trailing.equalTo(totalOverdueDescLabel.trailing);
        make.top.equalTo(totalOverdueDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:LabelBetweenMargin]);
        make.height.equalTo(@(17.0f));
    }];
    
    [loanToCreditRatioDescLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(dashLineView5.trailing);
        make.top.equalTo(dashLineView4.bottom).offset([UIDevice adaptLengthWithIphone6Length:DescLabelTopMargin]);
        make.height.equalTo(@(17.0f));
        make.trailing.equalTo(self);
    }];
    
    [loanToCreditRatioLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(loanToCreditRatioDescLabel.leading);
        make.trailing.equalTo(loanToCreditRatioDescLabel.trailing);
        make.top.equalTo(loanToCreditRatioDescLabel.bottom).offset([UIDevice adaptLengthWithIphone6Length:LabelBetweenMargin]);
        make.height.equalTo(@(17.0f));
    }];
}

-(void)setUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio
{
    [totalUseCreditLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",useCredit]]]];
    [totalCreditLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",credit]]]];
    [totalpendingLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalLoanPrincipleBalance]]]];
    [totalPayedLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalRefundPrincipal]]]];
    [totalOverdueLabel setText:[NSString stringWithFormat:@"%@",[AppUtils transferStringNumberToString:[NSString stringWithFormat:@"%lf",totalOverdueAmount]]]];
    [loanToCreditRatioLabel setText:[NSString stringWithFormat:@"%.2lf%%",(radio * 100)]];
}
@end
