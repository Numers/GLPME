//
//  UPLoginManager.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/7.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface UPLoginManager : NSObject
+(instancetype)shareManager;
-(void)loginWithName:(NSString *)name withPassword:(NSString *)password withSource:(NSString *)source isNotify:(BOOL)notify callback:(APIRequstCallBack)callback;

-(void)loginoutCallback:(APIRequstCallBack)callback;
@end
