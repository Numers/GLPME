//
//  InternetLoanStatisticsView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/9/12.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetLoanStatisticsView : UIView
-(void)makeConstrains;
-(void)setTotalUseCredit:(double)useCredit totalCurrentMonthUseCredit:(double)totalCurrentMonthUseCredit totalOverdueAmount:(double)totalOverdueAmount;
@end
