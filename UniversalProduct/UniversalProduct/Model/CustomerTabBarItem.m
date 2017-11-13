//
//  CustomerTabBarItem.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/12.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "CustomerTabBarItem.h"

@implementation CustomerTabBarItem
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (dic) {
        int iconNum = [[dic objectForKey:@"icon"] intValue];
        NSString *icon = [AppUtils unicodeIconWithHexint:iconNum];
        NSString *title = [dic objectForKey:@"title"];
        NSInteger imageSize = 25;
        id size = [dic objectForKey:@"imageSize"];
        if (size) {
            imageSize = [size integerValue];
        }
        NSString *color = [dic objectForKey:@"color"];
        NSString *selectedColor = [dic objectForKey:@"selectedColor"];
        self = [super initWithTitle:title image:[[UIImage iconWithInfo:TBCityIconInfoMake(icon, imageSize, [UIColor colorFromHexString:color])] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage iconWithInfo:TBCityIconInfoMake(icon, imageSize, [UIColor colorFromHexString:selectedColor])] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:color]} forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:selectedColor]} forState:UIControlStateSelected];
        if (self) {
            self.defaultField = [dic objectForKey:@"defaultField"];
            self.tag = [[dic objectForKey:@"tag"] integerValue];
        }
        return self;
    }
    return nil;
}
@end
