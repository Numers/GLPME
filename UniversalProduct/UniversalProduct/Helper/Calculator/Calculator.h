//
//  Calculator.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

/**
 计算数组元素的某个属性的和

 @param list 数组
 @param fieldName 属性名
 @return 总和
 */
+(double)sum:(NSArray *)list fieldName:(NSString *)fieldName;
@end
