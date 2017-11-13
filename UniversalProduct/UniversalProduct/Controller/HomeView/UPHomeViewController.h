//
//  UPHomeViewController.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/4/24.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPHomeViewController : UIViewController
@property(nonatomic) BOOL needAutoLogin;
-(void)reloadData;
-(void)pushPlatformPageWithAnimated:(BOOL)animated;
-(void)pushWebViewPage:(NSString *)url title:(NSString *)title WithAnimated:(BOOL)animated;
@end
