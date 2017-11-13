//
//  SortView.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/19.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SortViewProtocol <NSObject>
-(void)searchMore;
@end
@interface SortView : UIView
@property(nonatomic, assign) id<SortViewProtocol> delegate;
-(void)makeConstraints;
-(void)setSortList:(NSArray *)list;
@end
