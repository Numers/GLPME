//
//  Member.h
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    CustomerRole = 1,
    StaffRole
}Role;
@interface Member : NSObject
@property(nonatomic, copy) NSString *memberId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *loginName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *headIcon;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *source;
@property(nonatomic, copy) NSString *ip;
@property(nonatomic) NSTimeInterval time;
@property(nonatomic) Role role;

@property(nonatomic, strong) id userInfo;



/**
 字典初始化对象

 @param dic 用户信息字典
 @return 用户对象
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;


/**
 将用户对象转义成字典

 @return 用户信息字典
 */
-(NSDictionary *)dictionaryInfo;
@end
