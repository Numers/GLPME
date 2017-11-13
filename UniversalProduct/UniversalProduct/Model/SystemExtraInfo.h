//
//  SystemExtraInfo.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemExtraInfo : NSObject
@property(nonatomic, copy) NSString *field1;
@property(nonatomic, copy) NSAttributedString *field1Value;
@property(nonatomic, copy) NSString *field2;
@property(nonatomic, copy) NSAttributedString *field2Value;
@property(nonatomic, copy) NSString *field3;
@property(nonatomic, copy) NSAttributedString *field3Value;
@property(nonatomic, copy) NSString *field4;
@property(nonatomic, copy) NSAttributedString *field4Value;
@property(nonatomic, copy) NSString *field5;
@property(nonatomic, copy) NSAttributedString *field5Value;
@property(nonatomic, copy) NSString *field6;
@property(nonatomic, copy) NSAttributedString *field6Value;
@property(nonatomic, copy) NSString *field7;
@property(nonatomic, copy) NSAttributedString *field7Value;
@property(nonatomic, copy) NSString *field8;
@property(nonatomic, copy) NSAttributedString *field8Value;


-(instancetype)initWithArray:(NSArray *)arr;
@end
