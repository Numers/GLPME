//
//  HomeMiddleForCustomerView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMiddleForCustomerView : UIView
-(void)setFinanceLeaseUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;

-(void)setFactoryUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;

-(void)setColdChainsUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;

-(void)setAuthorizedLoanUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;

-(void)setInternetLoanUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;

-(void)setCrossBusinessUseCredit:(double)useCredit credit:(double)credit totalLoanPrincipleBalance:(double)totalLoanPrincipleBalance totalRefundPrincipal:(double)totalRefundPrincipal totalOverdueAmount:(double)totalOverdueAmount radio:(double)radio;

-(void)startTimer;
-(void)stopTimer;
@end
