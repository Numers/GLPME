//
//  SystemExtraInfo.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "SystemExtraInfo.h"
#import "ReportDetails.h"

@implementation SystemExtraInfo
-(instancetype)initWithArray:(NSArray *)arr
{
    self = [super init];
    if (self) {
        if (arr) {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    ReportDetails *details = [[ReportDetails alloc] initWithDictionary:dic];
                    [list addObject:details];
                }
            }
            
            NSDictionary *financeLeaseDic = [self calculateProjectTotalAmount:list projectId:@"1002"];
            double flUseTotal = [[financeLeaseDic objectForKey:@"useTotal"] doubleValue];
            double flCreditTotal = [[financeLeaseDic objectForKey:@"creditTotal"] doubleValue];
            NSDictionary *commercialFactoringDic = [self calculateProjectTotalAmount:list projectId:@"1003"];
            double cfUseTotal = [[commercialFactoringDic objectForKey:@"useTotal"] doubleValue];
            double cfCreditTotal = [[commercialFactoringDic objectForKey:@"creditTotal"] doubleValue];
            NSDictionary *coldChainsDic = [self calculateProjectTotalAmount:list projectId:@"1001"];
            double ccUseTotal = [[coldChainsDic objectForKey:@"useTotal"] doubleValue];
            double ccCreditTotal = [[coldChainsDic objectForKey:@"creditTotal"] doubleValue];
            
            flUseTotal /= 1000.0f;
            cfUseTotal /= 1000.0f;
            ccUseTotal /= 1000.0f;
            flCreditTotal /= 1000.0f;
            cfCreditTotal /= 1000.0f;
            ccCreditTotal /= 1000.0f;
            
            double allUseTotal = cfUseTotal + ccUseTotal + flUseTotal;
            double allCreditTotal = flCreditTotal + cfCreditTotal + ccCreditTotal;
            
            UIFont *unitFont, *allMoneyUnitFont;
            if (IS_IPHONE_4_OR_LESS) {
                unitFont = [UIFont systemFontOfSize:9.0f];
                allMoneyUnitFont = [UIFont systemFontOfSize:16.0f];
            }else if (IS_IPHONE_5){
                unitFont = [UIFont systemFontOfSize:9.0f];
                allMoneyUnitFont = [UIFont systemFontOfSize:16.0f];
            }else{
                unitFont = [UIFont systemFontOfSize:13.0f];
                allMoneyUnitFont = [UIFont systemFontOfSize:20.0f];
            }
            _field1 = @"累计用信(千元)";
            _field1Value = [self generateAttributeString:allUseTotal moneyFont:[UIFont systemFontOfSize:20] unit:@"" unitFont:allMoneyUnitFont color:[UIColor whiteColor]];
            _field2 = @"融资租赁(千元)";
            _field2Value = [self generateAttributeString:flUseTotal moneyFont:[UIFont systemFontOfSize:13] unit:@"" unitFont:unitFont color:[UIColor whiteColor]];
            _field3 = @"保理(千元)";
            _field3Value = [self generateAttributeString:cfUseTotal moneyFont:[UIFont systemFontOfSize:13] unit:@"" unitFont:unitFont color:[UIColor whiteColor]];
            _field4 = @"冷链(千元)";
            _field4Value = [self generateAttributeString:ccUseTotal moneyFont:[UIFont systemFontOfSize:13] unit:@"" unitFont:unitFont color:[UIColor whiteColor]];
            
            _field5 = @"累计授信(千元)";
            _field5Value = [self generateAttributeString:allCreditTotal moneyFont:[UIFont systemFontOfSize:20] unit:@"" unitFont:allMoneyUnitFont color:[UIColor colorFromHexString:@"#666666"]];
            _field6 = @"融资租赁(千元)";
            _field6Value = [self generateAttributeString:flCreditTotal moneyFont:[UIFont systemFontOfSize:13] unit:@"" unitFont:unitFont color:[UIColor colorFromHexString:@"#2A2A2A"]];
            _field7 = @"保理(千元)";
            _field7Value = [self generateAttributeString:cfCreditTotal moneyFont:[UIFont systemFontOfSize:13] unit:@"" unitFont:unitFont color:[UIColor colorFromHexString:@"#2A2A2A"]];
            _field8 = @"冷链(千元)";
            _field8Value = [self generateAttributeString:ccCreditTotal moneyFont:[UIFont systemFontOfSize:13] unit:@"" unitFont:unitFont color:[UIColor colorFromHexString:@"#2A2A2A"]];
        }
    }
    return self;
}

#pragma -mark private functions
-(NSDictionary *)calculateProjectTotalAmount:(NSArray *)list projectId:(NSString *)pid
{
    NSArray *pList = [self filterArray:list projectId:pid];
    if (pList) {
        double useTotal = 0.0f, creditTotal = 0.0f;
        for (ReportDetails *rd in pList) {
            if ([AppUtils isValidateNumericalValue:rd.useAmount]) {
                useTotal += [rd.useAmount doubleValue];
            }
            
            if ([AppUtils isValidateNumericalValue:rd.creditAmount]) {
                creditTotal += [rd.creditAmount doubleValue];
            }
        }
        NSDictionary *returnDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:useTotal],@"useTotal",[NSNumber numberWithDouble:creditTotal],@"creditTotal", nil];
        return returnDic;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:0.0f],@"useTotal",[NSNumber numberWithDouble:0.0f],@"creditTotal", nil];;
}

-(NSArray *)filterArray:(NSArray *)list projectId:(NSString *)pid
{
    if (list && pid) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.projectId == %@",pid];
        NSArray *filterArr = [list filteredArrayUsingPredicate:predicate];
        return filterArr;
    }
    return nil;
}

-(NSMutableAttributedString *)generateAttributeString:(double)money moneyFont:(UIFont *)mFont unit:(NSString *)unit unitFont:(UIFont *)uFont color:(UIColor *)color
{
    NSMutableAttributedString *moneyStr = [AppUtils generateAttriuteStringWithStr:[AppUtils transferStringNumberToString:[NSNumber numberWithDouble:money]] WithColor:color WithFont:mFont];
    NSMutableAttributedString *unitStr = [AppUtils generateAttriuteStringWithStr:unit WithColor:color WithFont:uFont];
    [moneyStr appendAttributedString:unitStr];
    return moneyStr;
}

-(double)raiseDownDecimalNumber:(double)value
{
    NSDecimalNumberHandler *roundDown = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *decimailUseTotal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",value]];
    NSDecimalNumber *transferUseTotal = [decimailUseTotal decimalNumberByRoundingAccordingToBehavior:roundDown];
    return [transferUseTotal doubleValue];
}
@end
