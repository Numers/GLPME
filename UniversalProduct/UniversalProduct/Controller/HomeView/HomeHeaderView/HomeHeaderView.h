//
//  HomeHeaderView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UIView
-(void)makeConstraints;
-(void)setTotalCredit:(double)totalCredit totalUseCredit:(double)totalUseCredit;
@end
