//
//  SystemInfo.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemExtraInfo.h"
@interface SystemInfo : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, copy) NSString *appUrl;
@property(nonatomic) NSInteger todo;

@property(nonatomic, copy) NSString *pushUrl;

@property(nonatomic, strong) NSMutableArray *systemExtraInfos;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
