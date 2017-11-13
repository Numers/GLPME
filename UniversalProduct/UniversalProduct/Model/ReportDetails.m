//
//  ReportDetails.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/6/13.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "ReportDetails.h"

@implementation ReportDetails
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        id creditAmount = [dic objectForKey:@"creditAmount"];
        if (creditAmount) {
            _creditAmount = [NSString stringWithFormat:@"%@",creditAmount];
        }
        
        id loanPrincipleBalance = [dic objectForKey:@"loanPrincipleBalance"];
        if (loanPrincipleBalance) {
            _loanPrincipleBalance = [NSString stringWithFormat:@"%@",loanPrincipleBalance];
        }
        
        id projectName = [dic objectForKey:@"projectName"];
        if (projectName) {
            _projectName = [NSString stringWithFormat:@"%@",projectName];
        }
        
        id projectId = [dic objectForKey:@"projectId"];
        if (projectId) {
            _projectId = [NSString stringWithFormat:@"%@",projectId];
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
        
        id totalOverdueAmount = [dic objectForKey:@"totalOverdueAmount"];
        if (totalOverdueAmount) {
            _totalOverdueAmount = [NSString stringWithFormat:@"%@",totalOverdueAmount];
        }
        
        id totalRefundPrincipal = [dic objectForKey:@"totalRefundPrincipal"];
        if (totalRefundPrincipal) {
            _totalRefundPrincipal = [NSString stringWithFormat:@"%@",totalRefundPrincipal];
        }
        
        id useAmount = [dic objectForKey:@"useAmount"];
        if (useAmount) {
            _useAmount = [NSString stringWithFormat:@"%@",useAmount];
        }
        
        id totalCreditAmount = [dic objectForKey:@"totalCreditAmount"];
        if (totalCreditAmount) {
            _totalCreditAmount = [NSString stringWithFormat:@"%@",totalCreditAmount];
        }
        
        id totalUseAmount = [dic objectForKey:@"totalUseAmount"];
        if (totalUseAmount) {
            _totalUseAmount = [NSString stringWithFormat:@"%@",totalUseAmount];
        }
    }
    return self;
}
@end
