//
//  UPLoginManager.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/7.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UPLoginManager.h"

@implementation UPLoginManager
+(instancetype)shareManager
{
    static UPLoginManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UPLoginManager alloc] init];
    });
    return manager;
}

-(void)loginWithName:(NSString *)name withPassword:(NSString *)password withSource:(NSString *)source isNotify:(BOOL)notify callback:(APIRequstCallBack)callback
{
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",password,@"password",source,@"source",@(-1),@"expires", nil];
    [[NetWorkRequestManager shareManager] post:UP_Login_API parameters:paras callback:callback isNotify:notify];
}

-(void)loginoutCallback:(APIRequstCallBack)callback
{
    [[NetWorkRequestManager shareManager] put:UP_loginout_API parameters:nil callback:callback isNotify:YES];
}
@end
