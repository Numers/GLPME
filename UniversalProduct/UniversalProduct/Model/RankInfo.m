//
//  RankInfo.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/20.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "RankInfo.h"

@implementation RankInfo
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic) {
            _rank = [[dic objectForKey:@"rank"] integerValue];
            _employeeId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"employeeId"]];
            _employeeName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"employeeName"]];
            NSString *tempUseAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"useAmount"]];
            if ([AppUtils isValidateNumericalValue:tempUseAmount]) {
                _useAmount = [NSString stringWithFormat:@"%lf",([tempUseAmount doubleValue] / UnitDivisor)];
            }
            
            NSString *tempTotalUseAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalUseAmount"]];
            if ([AppUtils isValidateNumericalValue:tempTotalUseAmount]) {
                _totalUseAmount = [NSString stringWithFormat:@"%lf",([tempTotalUseAmount doubleValue] / UnitDivisor)];
            }
            
            id statisticsDay = [dic objectForKey:@"statisticsDay"];
            if (statisticsDay) {
                _statisticsDay = [NSString stringWithFormat:@"%@",statisticsDay];
            }
            
            id statisticsFinanceYear = [dic objectForKey:@"statisticsFinanceYear"];
            if (statisticsFinanceYear) {
                _statisticsFinanceYear = [NSString stringWithFormat:@"%@",statisticsFinanceYear];
            }
            
            id statisticsMonth = [dic objectForKey:@"statisticsMonth"];
            if (statisticsMonth) {
                _statisticsMonth = [NSString stringWithFormat:@"%@",statisticsMonth];
            }
            
            id statisticsYear = [dic objectForKey:@"statisticsYear"];
            if (statisticsYear) {
                _statisticsYear = [NSString stringWithFormat:@"%@",statisticsYear];
            }

        }
    }
    return self;
}
@end
