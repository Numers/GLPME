//
//  HomeMiddleForStaffView.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "HomeMiddleForStaffView.h"
#import "StatisticsView.h"
#import "SortView.h"
@interface HomeMiddleForStaffView()<SortViewProtocol>
{
    StatisticsView *statisticsView;
    SortView *sortView;
}

@end
@implementation HomeMiddleForStaffView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorFromHexString:@"#F6F6F6"]];
        statisticsView = [[StatisticsView alloc] initWithFrame:CGRectMake(0, 0, GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:143.0f])];
        [self addSubview:statisticsView];
        
        sortView = [[SortView alloc] initWithFrame:CGRectMake(0, statisticsView.frame.size.height + [UIDevice adaptLengthWithIphone6Length:8.0f], GDeviceWidth, [UIDevice adaptLengthWithIphone6Length:156.0f])];
        sortView.delegate = self;
        [self addSubview:sortView];
        [sortView makeConstraints];
        
    }
    return self;
}

#pragma -mark set
-(void)setFinanceLeaseTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (statisticsView) {
        [statisticsView setFinanceLeaseTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setFactoryTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (statisticsView) {
        [statisticsView setFactoryTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setColdChainsTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (statisticsView) {
        [statisticsView setColdChainsTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setAuthorizedLoanTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (statisticsView) {
        [statisticsView setAuthorizedLoanTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setCrossBusinessTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (statisticsView) {
        [statisticsView setCrossBusinessTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setInternetLoanTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount
{
    if (statisticsView) {
        [statisticsView setInternetLoanTotalUseCredit:useCredit totalCurrentMonthUseCredit:totalCurrentMonthUseCredit totalOverdueAmount:totalOverdueAmount];
    }
}

-(void)setSortList:(NSArray *)list
{
    if (sortView) {
        [sortView setSortList:list];
    }
}

#pragma -mark SortViewProtocol
-(void)searchMore
{
    if ([self.delegate respondsToSelector:@selector(pushToWebPage)]) {
        [self.delegate pushToWebPage];
    }
}
@end
