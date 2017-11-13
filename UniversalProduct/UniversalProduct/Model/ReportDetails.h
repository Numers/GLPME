//
//  ReportDetails.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/6/13.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportDetails : NSObject
@property(nonatomic, copy) NSString *creditAmount;
@property(nonatomic, copy) NSString *loanPrincipleBalance;
@property(nonatomic, copy) NSString *projectName;
@property(nonatomic, copy) NSString *projectId;
@property(nonatomic, copy) NSString *statisticsDay;
@property(nonatomic, copy) NSString *statisticsFinanceYear;
@property(nonatomic, copy) NSString *statisticsMonth;
@property(nonatomic, copy) NSString *statisticsYear;
@property(nonatomic, copy) NSString *totalOverdueAmount;
@property(nonatomic, copy) NSString *totalRefundPrincipal;
@property(nonatomic, copy) NSString *useAmount;
@property(nonatomic, copy) NSString *totalCreditAmount;
@property(nonatomic, copy) NSString *totalUseAmount;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
