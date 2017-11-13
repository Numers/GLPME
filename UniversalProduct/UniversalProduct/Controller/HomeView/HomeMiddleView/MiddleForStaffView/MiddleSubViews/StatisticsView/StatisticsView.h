//
//  StatisticsView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsView : UIView
-(void)setFinanceLeaseTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
-(void)setFactoryTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
-(void)setColdChainsTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
-(void)setAuthorizedLoanTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
-(void)setCrossBusinessTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
-(void)setInternetLoanTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
@end
