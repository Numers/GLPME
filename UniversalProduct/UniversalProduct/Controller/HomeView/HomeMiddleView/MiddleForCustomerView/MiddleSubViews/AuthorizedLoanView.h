//
//  AuthorizedLoanView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/9/14.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizedLoanView : UIView
-(void)makeConstraints;
-(void)setUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;
@end
