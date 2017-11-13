//
//  MenuItem.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTreeNode;
@interface MenuItem : NSObject
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *title;
@property(nonatomic) id defaultField;

@property(nonatomic, strong) NSMutableArray *childMenuItems;

-(instancetype)initWithDictionary:(NSDictionary *)dic withParentNode:(MTreeNode *)fNode;
@end
