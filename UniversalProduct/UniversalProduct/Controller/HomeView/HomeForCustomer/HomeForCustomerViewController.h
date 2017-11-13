//
//  HomeForCustomerViewController.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeForCustomerViewController : UIViewController
-(void)pushPlatformPageWithAnimated:(BOOL)animated;
-(void)pushWebViewPage:(NSString *)url title:(NSString *)title WithAnimated:(BOOL)animated;
@end
