//
//  Calculator.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator
+(double)sum:(NSArray *)list fieldName:(NSString *)fieldName
{
    double result = 0;
    if(list && list.count > 0){
        for (id obj in list) {
            id value = [obj valueForKey:fieldName];
            if (value) {
                if([AppUtils isValidateNumericalValue:[NSString stringWithFormat:@"%@",value]]){
                    result = result + [value doubleValue];
                }
            }
        }
    }
    return result;
}
@end
