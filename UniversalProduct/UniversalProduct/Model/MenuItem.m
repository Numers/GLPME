//
//  MenuItem.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/4.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "MenuItem.h"
#import "MTreeNode.h"

@implementation MenuItem
-(instancetype)initWithDictionary:(NSDictionary *)dic withParentNode:(MTreeNode *)fNode
{
    self = [super init];
    if (self) {
        if (dic) {
            int iconNum = [[dic objectForKey:@"icon"] intValue];
            _icon = [AppUtils unicodeIconWithHexint:iconNum];
            _title = [dic objectForKey:@"title"];
            _defaultField = [dic objectForKey:@"defaultField"];
            _childMenuItems = [NSMutableArray array];
            NSArray *childInfos = [dic objectForKey:@"child"];
            if (childInfos && childInfos.count > 0) {
                for (NSDictionary *childDic in childInfos) {
                    MTreeNode *subnode = [MTreeNode initWithParent:fNode expand:NO];
                    MenuItem *item = [[MenuItem alloc] initWithDictionary:childDic withParentNode:subnode];
                    subnode.content = item;
                    [fNode.subNodes addObject:subnode];
                }
            }
        }
    }
    return self;
}
@end
