//
//  SystemInfo.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "SystemInfo.h"

@implementation SystemInfo
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic) {
            _name = [dic objectForKey:@"name"];
            _logo = [dic objectForKey:@"logo"];
            _appUrl = [dic objectForKey:@"appUrl"];
            _systemExtraInfos = [NSMutableArray array];
            id state = [dic objectForKey:@"stat"];
            if (state) {
                id summary = [state objectForKey:@"summary"];
                if (summary) {
                    _todo = [[summary objectForKey:@"todo"] integerValue];
                }
                
            }
            
        }
    }
    return self;
}
@end
