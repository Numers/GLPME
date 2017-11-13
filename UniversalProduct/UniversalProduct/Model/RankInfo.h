//
//  RankInfo.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/20.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankInfo : NSObject
@property(nonatomic) NSInteger rank;
@property(nonatomic, copy) NSString *employeeId;
@property(nonatomic, copy) NSString *employeeName;
@property(nonatomic, copy) NSString *useAmount;
@property(nonatomic, copy) NSString *totalUseAmount;
@property(nonatomic, copy) NSString *statisticsDay;
@property(nonatomic, copy) NSString *statisticsFinanceYear;
@property(nonatomic, copy) NSString *statisticsMonth;
@property(nonatomic, copy) NSString *statisticsYear;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
