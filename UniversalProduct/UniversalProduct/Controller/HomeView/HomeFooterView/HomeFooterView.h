//
//  HomeFooterView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeFooterViewProtocol <NSObject>
-(void)pushToPlatformPageWithName:(NSString *)name;
@end
@interface HomeFooterView : UIView
@property(nonatomic, assign) id<HomeFooterViewProtocol> delegate;
-(void)makeConstraints;
-(void)setPlatformList:(NSMutableArray *)list;
@end
