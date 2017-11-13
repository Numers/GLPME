//
//  UPHomeManager.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface UPHomeManager : NSObject
+(instancetype)shareManager;

-(void)requestSystemInfo:(APIRequstCallBack)callback;
-(void)requestReport:(APIRequstCallBack)callback;

-(void)requestProjectReport:(NSString *)financialYear callback:(APIRequstCallBack)callback;
-(void)requestCustomerReport:(NSString *)financialYear callback:(APIRequstCallBack)callback;
-(void)requestRankReport:(NSString *)financialYear month:(NSString *)month callback:(APIRequstCallBack)callback;
@end
