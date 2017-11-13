//
//  UPHomeManager.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPHomeManager.h"

@implementation UPHomeManager
+(instancetype)shareManager
{
    static UPHomeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UPHomeManager alloc] init];
    });
    return manager;
}

-(void)requestSystemInfo:(APIRequstCallBack)callback
{
    [[NetWorkRequestManager shareManager] get:UP_systemInfo_API parameters:nil callback:callback isNotify:YES];
}

-(void)requestReport:(APIRequstCallBack)callback
{
    [[NetWorkRequestManager shareManager] get:UP_Report_API parameters:nil callback:callback isNotify:YES];
}

-(void)requestProjectReport:(NSString *)financialYear callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = nil;
    if (financialYear) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:financialYear,@"year", nil];
    }
    [[NetWorkRequestManager shareManager] get:UP_Report_Project_API parameters:parameters callback:callback isNotify:YES];
}
-(void)requestCustomerReport:(NSString *)financialYear callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = nil;
    if (financialYear) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:financialYear,@"year", nil];
    }
    [[NetWorkRequestManager shareManager] get:UP_Report_Customer_API parameters:parameters callback:callback isNotify:YES];
}
-(void)requestRankReport:(NSString *)financialYear month:(NSString *)month callback:(APIRequstCallBack)callback
{
    NSDictionary *parameters = nil;
    if (financialYear && month) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:financialYear,@"year",month,@"month", nil];
    }
    [[NetWorkRequestManager shareManager] get:UP_Report_Manager_Rank_API parameters:parameters callback:callback isNotify:YES];
}
@end
